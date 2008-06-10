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
               frequency = clock_const + clock_const*30*1e-6*(rnd-0.5);  
       }
       else if(stage == 1) {
	       random_start = 0 ;
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
               if(dblrand() < 0.5){break;}else
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
       
       int medium_value = (int) neigh / 2 ;
       double median;
       double add_on ;
       add_on = temp_varr[0] ;

       for(int k=0;k<neigh;k++)
	 temp_varr[k] = temp_varr[k] - add_on ;

       if(neigh ==0)
               median = 0 ;
       else if ( neigh == 1)
               median = temp_varr[neigh] ;
       else
               median = 0.5 *(temp_varr[medium_value - 1] + temp_varr[medium_value]) ;

       switch(algorithm){

// Weighted Measurments ............

       case 1:{ 
		offset = 0 ;
		double maxx  ;
                double fasika ;
                double weight[SIZE_OF_NETWORK];
                double tempp[SIZE_OF_NETWORK] ;
                double sum = 0 ;

                for(int af = 0 ; af < neigh ; af ++) {
                        tempp[af] = abs(temp_varr[af]-median);
                        sum = sum + tempp[af] ;
                }
                if(tempp[0] >= tempp[neigh-1])
                maxx = tempp[0] ;
                else 
                maxx = tempp[neigh-1] ;

                if(sum==0)
                        offset = 0 ;
                else{
                fasika = (neigh * sum) - sum ;
                for (int m=0; m < neigh; m++){
			if(fasika !=0)
                         weight[m] = (sum - tempp[m]) / fasika ;
			else 
			 weight[m] = 0 ;
                         offset = offset + (temp_varr[m] * weight[m]) ;
                }}
		offset += add_on ;
                break;}
       case 2:{

// Median .........with a gain 
               offset = median ;
               offset += add_on ;
               break;}

       case 3:{

// Kalman filter .....

               	double x; // estimated value of the variable to be considered 
		double phi; // coefficient to bla bla the previous estimate in it
		double z;   // measured value
		double H;  // adjustment matrix
		double R;  // noise covariance
		double P;  // error covariance 
		double Ka;  // Kalman gain 
		double Q;  // noise covariance  
		double B;  // control coefficient 
		double U;  // control factor 
		// Initialize the matrices 

		x = offset ; // Initial estimate 
		P = 0 ; // Initial estimate of covariance matrix - error covariance matrix

		phi = 1 ;
		Q = 1 ;
		R = 1 ;
		H = 1 ;
		B = 0 ;

		// Loop 

		for(int i=0;i<neigh;i++){
			
			// Time update "PREDICT"

			x = phi*x + B*U ;
			P = (phi * P) * (1/phi) + Q ;

			// Measurment Update "CORRECT"

			// Compute Kalman gain

			Ka = P * H ; // ( ( H * P * H ) + R);	

			// update estimate with measurement

			x = x + Ka * (temp_varr[i] - (H * x) );

			// update the error covariance

			P = ( 1 - (Ka * H)) * P;	
			}
			offset = x ;
          		offset += add_on ;
               break;}
       case 4:{

// Curve fitting - logarithmic 

               double a,b,sum,sumsq,sumprod,sumprodsum,sumy = 0;
               int varr = 1 ;
               bool change = false ;  
               double cmp = 30e-6 ;
               for(int k=0 ; k<count ; k++){
                       if((temp_varr[k] >= 0) && (change == false)){
                               varr = k+1 ;
                               change = true;
                       }
		       sumy += (temp_varr[k] + cmp);
                       sum += log(k+1);
                       sumsq += pow(log(k+1),2);
                       sumprod += (temp_varr[k]+cmp) * log(k+1);   
               }

               for(int k=0;k<count;k++){
                       sumprodsum += (temp_varr[k] + cmp)*sum ;
               }

               b = (count*sumprod - sumy*sum)/(count*sumsq - (sum*sum));
               a = (sumy - b*sum) / count ;
               offset = a + b*log((double)count/2) ;
	       offset = offset - cmp ;	
               offset += add_on ;
       }
       case 5:{

// MMSE estimator ....

		double x;    // estimated value of the variable to be considered 
		double W;    // weight matrix
		double H;    // coefficient matrix  

		x = 1e-6 ;   // Initial estimate 
		W = 1 ;      // Initialization of the weight matrix
		H = 1 ;
		
  		// Loop 

		for(int i=0;i<neigh;i++){
			x = (H*W*temp_varr[i])/(H*W*H) ;
			W = W * 1 ;
			H = H * 1 ;
		}
		offset = x ;
		offset += add_on ;
	        break;
	}
       default:
               offset = 0;
               break;
       }
/*
       offset = 0 ;
       if(Period%jump != 0)
               offset = 0 ;

       if (ev.isGUI())
    		bubble("Going down!");
       cDisplayString *dispStr = displayString();
       displayString -> */
       broadcast_time = broadcast_time - gain*offset + frequency ;
       Ref = Ref - gain*offset + frequency ;

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

