#include "MacLayer.h"
#include "math.h"
//---omnetpp part----------------------
Define_Module(MacLayer);

//---intialisation---------------------

void MacLayer::initialize(int stage) {
	
	hostCount = parentModule()->par("hosts");
	periodCount = parentModule()->par("limit");
	algorithm  = parentModule()->par("algorithm");
	gain = parentModule() ->par("gain");
	jump = parentModule() ->par("jump") ;
	BaseModule::initialize(stage);
        
	if(stage == 0) {
		myIndex = parentModule()->par("id") ;
		Period = 0 ;
		count = 0;
		Period = 0 ;
		dataOut = findGate("lowerGateOut");
		dataIn = findGate("lowerGateIn");
		controlOut = findGate("lowerControlOut");
		controlIn = findGate("lowerControlIn");
		random_start = (double) parentModule()->par("start_time") / hostCount;
		if(random_start < 0.5)
		frequency = clock_const + clock_const*random_start ;
		else 
		frequency = clock_const - clock_const*random_start ;
		
	} 
	else if(stage == 1) {
		broadcast_time = parentModule()->par("start_time");
		MacPkt* pkt = createMacPkt(frame_length);
		scheduleAt(broadcast_time, pkt);

		cMessage *ctrl = new cMessage("Control Message");
		Ref = 0.5*clock_const ;
		Period++ ;
		ctrl->setKind(CONTROL_MESSAGE);
		scheduleAt(Ref,ctrl);
	}
}

void MacLayer::handleMessage(cMessage* msg) {
	if( msg->kind() == BROADCAST_MESSAGE ){
		log("Sending Broadcast Messages to the physical Layer ....");
		output_vec.record(broadcast_time*1000000) ;
		sendDown(msg);
	}
	else if ( msg->kind() == CONTROL_MESSAGE){
		log("Control Message Received - Updating the period ...") ;
		if((Period!=periodCount))
		     analyze_msg();
		else{ 
		     callFinish() ;
		}delete msg;
	}else{	
		log("Collecting the offsets from Neighbours ....");
		collect_data(msg);
		delete msg ;
	}
}
void MacLayer::sendDown(cMessage *pkt)
{
	send(pkt, dataOut);
}
void MacLayer::analyze_msg()
{	
	log("Adjusting the offset of ") ;
	int neigh = count;
        output_vec.record(neigh) ;
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
	double offset = 0 ;
	int medium_value = (int) neigh / 2 ;
	double median = 0.5 *(temp_varr[medium_value - 1] + temp_varr[medium_value]) ;
	switch(algorithm){
	case 1:{
		double average ;
		if(neigh != 0)
		average = total / neigh ;
		else
		average = 0 ;
		offset = average ;
		break;}
	case 2:{
		offset = median ;
		break;}
	case 3:{
		double weight[SIZE_OF_NETWORK];
		double tempp[SIZE_OF_NETWORK] ;
		double sum = 0 ;

		for(int af = 0 ; af < neigh ; af ++) {
			tempp[af] = abs(temp_varr[af]-median);
			sum = sum + tempp[af] ;
		}
		if(sum==0)
			offset = 0 ;
		else{
		for (int m=0; m < neigh; m++){
			 if(neigh != 1){
		         weight[m]= (1 - tempp[m]/sum)/(neigh-1) ; 
			 weight[m] = sqrt(weight[m]) ;
			 }else
			 weight[m] = 1 ;
		  	 offset = offset + ( temp_varr[m] * weight[m] ) ;
		}
		}
		offset = offset * gain ;
		break;}
	case 4:{
		double maxx  ;
		double fasika ;
		double weight[SIZE_OF_NETWORK];
		double tempp[SIZE_OF_NETWORK] ;
		double sum = 0 ;
		temp_varr[neigh] = 0 ;
		for(int af = 0 ; af < neigh+1 ; af ++) {
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
                fasika = ((neigh+1) * maxx) - sum ;
		for (int m=0; m < neigh+1; m++){
		         weight[m]= (maxx - tempp[m]) / fasika ;
			 offset = offset + (temp_varr[m] * weight[m]) ;
		}
 		}
		offset = offset * gain ;
		break;}
	default:
		offset = 0;
		break;
	}

	if(Period%jump != 0)
	offset = 0 ;
	broadcast_time = broadcast_time - gain*offset + frequency ;

        MacPkt* pkt = createMacPkt(frame_length);
	scheduleAt(broadcast_time,pkt) ;
	count = 0 ;
	cMessage *ctrl = new cMessage("bla bla");
	Ref = Ref + clock_const ;
	Period++ ;
	ctrl->setKind(CONTROL_MESSAGE);
	scheduleAt(Ref,ctrl);
}
void MacLayer::collect_data(cMessage *pkt)
{	
	clock_drift = (temperature - 25 )* exp(-6) * 0.5 / 20 ;
	temp_varr[count] = broadcast_time - simTime() +  clock_drift;
	count++;
	log("Recording the simulation values");
}
void MacLayer::finish()
{
	double period = broadcast_time ;
	recordScalar("Time at last", period );
}

void MacLayer::log(std::string msg)
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
