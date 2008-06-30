#include "MacLayer.h"
#include "math.h"

//---omnetpp part----------------------


Define_Module(MacLayer);

//---intialisation---------------------

void MacLayer::initialize(int stage) {
       
       hostCount = parentModule()->par("hosts");
       algorithm  = parentModule()->par("algorithm");
       gain = parentModule() ->par("gain");
       jump = parentModule() ->par("jump") ;
       BaseModule::initialize(stage);
       rnd = parentModule()->par("start_time") ;
       
       if(stage == 0) {
               myIndex = parentModule()->par("id") ;
               Period = 0 ;
               count = 0;
               Period = 0 ;
               Ref = 0 ;
               dataOut = findGate("lowerGateOut");
               dataIn = findGate("lowerGateIn");
               controlOut = findGate("lowerControlOut");
               controlIn = findGate("lowerControlIn");
               random_start = rnd * 29/32768 ;
               frequency = clock_const + clock_const*30*1e-6*(rnd-0.5)*2;  
       }
       else if(stage == 1) {
//	       random_start = 0  ;
               broadcast_time = random_start;
               MacPkt* pkt = createMacPkt(frame_length);
               scheduleAt(broadcast_time, pkt);

               cMessage *ctrl = new cMessage("Control Message");
               Ref = broadcast_time + 0.5*frequency ;
               Period++ ;
               ctrl->setKind(CONTROL_MESSAGE);
               scheduleAt(Ref,ctrl);
       }
}

void MacLayer::handleMessage(cMessage* msg) {
       if( msg->kind() == BROADCAST_MESSAGE ){
               logg("Sending Broadcast Messages to the physical Layer ....");
               output_vec.record(broadcast_time*1000000) ;
               sendDown(msg);
       }
       else if ( msg->kind() == CONTROL_MESSAGE){
               logg("Control Message Received - Updating the period ...") ;
               analyze_msg();
               delete msg;
       }else{  
               logg("Collecting the offsets from Neighbours ....");
//               if(dblrand() > 0.5)
               collect_data(msg);
               delete msg ;
       }
}
void MacLayer::sendDown(cMessage *pkt)
{
       send(pkt, dataOut);
}

void MacLayer::collect_data(cMessage *pkt)
{      
       clock_drift = (temperature - 25 )*(temperature - 25)*-0.035*exp(-6);
       temp_varr[count] = broadcast_time - simTime() +  clock_drift;
       count++;
       logg("Recording the simulation values");
}

void MacLayer::analyze_msg()
{      
       logg("Adjusting the offset of ") ;
       int neigh = count;
       double total = 0 ;
       double median = 0;
       double add_on ;

       for(int x = 0; x < neigh; x ++) {		
               for(int y = x+1; y < neigh; y ++) {
                               if(temp_varr[y] < temp_varr[x]) {
                                       double temp = temp_varr[x];
                                       temp_varr[x] = temp_varr[y];
                                       temp_varr[y] = temp;
                               }
               }
               total = total + temp_varr[x] ;
       }


       if(neigh!=0)
       add_on = temp_varr[0] ;
       else 
       add_on = 0 ;

       for(int k=0;k<neigh;k++)
	 temp_varr[k] = temp_varr[k] - add_on ;

       if(neigh == 0)
               median = 0 ;
       else if ( neigh == 1)
               median = 0.5 * temp_varr[0] ;
       else if( neigh%2 == 0)
               median = 0.5 *(temp_varr[neigh/2 -1] + temp_varr[neigh/2]) ; 
       else if (neigh%2 == 1)
	       median = temp_varr[(neigh+1)/2 -1 ] ;

       switch(algorithm){
       case 1:{

// Kalman filter .....

               	double x;   // estimated value of the variable to be considered 
		double phi; // coefficient to bla bla the previous estimate in it
		double H;   // adjustment matrix
		double R;   // noise covariance
		double P;   // error covariance 
		double Ka;  // Kalman gain 
		double Q;   // noise covariance  

		// Initialize the matrices 

		x = offset ; // Initial estimate 
		P = 1 ; // Initial estimate of covariance matrix - error covariance matrix
		
		Q = 1; // covariance matrix - 
		R = 1e-6;
		H = 1;
		phi = 1;

		// Loop 

		for(int i=0;i<neigh;i++){
			
			// Time update "PREDICT"

			x = phi*x ;  
			P =  phi*P*phi + Q ;

			// Measurment Update "CORRECT"

				// Compute Kalman gain

			Ka = P * H /(( H * P * H ) + R);	

				// update estimate with measurement

			x = x + Ka * (temp_varr[i] - (H * x) );

				// update the error covariance

			P = ( 1 - (Ka * H)) * P;	
		}
			offset  = gain*x ;
			if(offset !=0)
          		offset += add_on ;
               break;}
      case 2:{
// Median .........
               offset = gain*median ;
	       if(median!=0)		
               offset += add_on ;
               break;}

// Weighted Measurments ..........  

       case 3:{ 
		offset = 0 ;
		int factor = 1 ;
                double fasika ;
                double weight[100];
                double sum = 0 ;
		double sumcons = 0 ;
		double cons = 1 ;
		for(int i = 0 ; i < count ; i++){
			if(temp_varr[i] < 9*30*1e-6)
				cons = 0.9 ;
			else if( temp_varr[i] < 18*30*1e-6)
				cons = 0.6 ;
			else if( temp_varr[i] < 27*30*1e-6)
				cons = 0.3 ;
			else 
				cons = 0.01 ;
		        temp_varr[i] = cons * temp_varr[i] ;
			sum += temp_varr[i] ;
			sumcons += cons ;
		}
	
	       /* if(neigh==0){offset = 0 ;}else if(neigh==1){offset = temp_varr[0];}else{
                /*fasika =  sum * (neigh-1*factor) ;
                for (int m=0; m < neigh; m++){
			if(fasika !=0)
                         weight[m] = (sum - factor*temp_varr[m]) / fasika ;
			else 
			 weight[m] = 0 ;

                         offset = offset + (temp_varr[m] * weight[m]) ;
                }}*/
		if(sumcons!=0){
		offset = sum / sumcons ;
		offset = offset * gain ;
		offset += add_on ;}
                else
		offset = 0 ;
		break;}
       case 4:{
// Non-linear least square curve fitting 
		double a,b, sum, sumlog, sumprod, sumsq = 0 ;
		double ga = 30*1e-6 ;
		if(count == 0)
			offset = 0 ;
		else if(count == 1)
		    offset = temp_varr[0]/ 2 ;
		else{
			for(int i = 0;i<count;i++){
				sum += temp_varr[i]/ga;
				sumlog += 0.4*(double)(i+1);
				sumprod += (temp_varr[i]/ga)*0.4*(double)(i+1);
				sumsq += 0.16*(double)(i+1)*(double)(i+1);
			}
			double control = count*sumsq - sumlog*sumlog ;
			if(control!=0){
			b = (count*sumprod - sum*sumlog)/control;
			a = (sum - b*sumlog)/count;
			offset = a + b*log((double)(count/2 + 1));}
			else offset = 0 ;
			offset = offset * ga ;
		}
		offset = offset * gain ;
		offset  += add_on ;
		offset = gain*median ;
	        if(median!=0)		
                offset += add_on ;
		offset = 0 ;
		break;}
       default:
               offset = 0;
               break;
       }

       broadcast_time = broadcast_time - offset + frequency ;
       Ref = Ref - offset + frequency ;

       MacPkt* pkt = createMacPkt(frame_length);
       scheduleAt(broadcast_time,pkt) ;

       cMessage *ctrl = new cMessage("Control Message");
       Period++;
       ctrl->setKind(CONTROL_MESSAGE);
       scheduleAt(Ref,ctrl);

       for(int k=0;k<count;k++)
               temp_varr[count] = 0 ;       

       count = 0 ;

}

void MacLayer::finish()
{
       recordScalar("Time at last", broadcast_time);
}

void MacLayer::logg(std::string msg)
{
       ev << "[Node " << myIndex << "] - MacLayer: " << msg << endl;
}


MacPkt* MacLayer::createMacPkt(simtime_t length) {
       Signal* s = new Signal(broadcast_time, length);
       MacToPhyControlInfo* ctrl = new MacToPhyControlInfo(s);
       MacPkt* res = new MacPkt();
       res->setControlInfo(ctrl);
       res->setKind(BROADCAST_MESSAGE);
       res->setDestAddr(nextReceiver);
       return res;
}
