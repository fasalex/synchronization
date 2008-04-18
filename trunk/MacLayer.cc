#include "MacLayer.h"

//---omnetpp part----------------------
Define_Module(MacLayer);

//---intialisation---------------------

void MacLayer::initialize(int stage) {
	
	hostCount = parentModule()->par("hosts");
	periodCount = parentModule()->par("limit");
	algorithm  = parentModule()->par("algorithm");
	gain = parentModule() ->par("gain");
	BaseModule::initialize(stage);

	if(stage == 0) {
		myIndex = parentModule()->par("id") ;
		Period[myIndex] = 0 ;
		count[myIndex] = 0;
		Period[myIndex] = 0 ;
		dataOut = findGate("lowerGateOut");
		dataIn = findGate("lowerGateIn");
		controlOut = findGate("lowerControlOut");
		controlIn = findGate("lowerControlIn");
		
		phy = FindModule<MacToPhyInterface*>::findSubModule(this->parentModule());
		
	} 
	else if(stage == 1) {
		broadcast_time[myIndex] = parentModule()->par("start_time");
		MacPkt* pkt = createMacPkt(frame_length);
		scheduleAt((int)broadcast_time[myIndex], pkt);
	
		cMessage *ctrl = new cMessage("Control Message");
		Ref[myIndex] = 0.5*clock_const ;
		Period[myIndex]++ ;
		ctrl->setKind(CONTROL_MESSAGE);
		scheduleAt(Ref[myIndex],ctrl);
	}
	
}

void MacLayer::handleMessage(cMessage* msg) {
	
	if( msg->kind() == BROADCAST_MESSAGE ){
		log("Sending Broadcast Messages to the physical Layer ....");
		output_vec.record(broadcast_time[myIndex]) ;			
		sendDown(msg);
	}
	else if ( msg->kind() == CONTROL_MESSAGE){
		log("Control Message Received - Updating the period ...") ;
		if((Period[myIndex]!=periodCount))
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
	int neigh = count[myIndex];
	double total = 0 ;
	for(int x = 0; x < neigh; x ++) {
		for(int y = x+1; y < neigh; y ++) {
     				if(temp_varr[myIndex][y] < temp_varr[myIndex][x]) {
               				double temp = temp_varr[myIndex][x];
               				temp_varr[myIndex][x] = temp_varr[myIndex][y];
               				temp_varr[myIndex][y] = temp;
				}
		}
                total = total + temp_varr[myIndex][x] ;
        }
	double offset ;
	switch(algorithm){
/////// Median algorithm ...	
	case 2:{
		int medium_value = (int) neigh / 2 ;
		offset = 0.5 *(temp_varr[myIndex][medium_value - 1] + temp_varr[myIndex][medium_value]) ;
		break;}
/////// Mean algorithm ...	
	case 1:{
		double average ;
		if(neigh != 0)
		average = total / neigh ;
		else
		average = 0 ;
		offset = average ;
		break;}
////// Weight ....
	case 3:{
		double Rxx[SIZE_OF_NETWORK];
		for (int m=1; m < neigh+1; m++){
   			for (int n=1;n <neigh-m+1 ; n++)
      				Rxx[m]=Rxx[m]+temp_varr[myIndex][n]*temp_varr[myIndex][n+m-1];
   		}
		offset = 0 ;
		break;}
	default:
		offset = 0;
		break;
	}
	broadcast_time[myIndex] = broadcast_time[myIndex] - gain*offset + clock_const ;
	MacPkt* pkt = createMacPkt(frame_length);
	scheduleAt((int)broadcast_time[myIndex],pkt) ;
	count[myIndex] = 0 ;
	cMessage *ctrl = new cMessage("Control Message");
	Ref[myIndex] = Ref[myIndex] + clock_const ;
	Period[myIndex]++ ;
	ctrl->setKind(CONTROL_MESSAGE);
	scheduleAt(Ref[myIndex],ctrl);

}
void MacLayer::collect_data(cMessage *pkt)
{	
	simtime_t prop_delay = pkt->timestamp();
	clock_drift = (temperature - 25 )* exp(-6) * 0.5 / 20 ;
	temp_varr[myIndex][count[myIndex]] = broadcast_time[myIndex] - simTime() + prop_delay + clock_drift;
	count[myIndex]++;
	log("Recording the simulation values");
//	output_vec.record(simTime()) ;
}
void MacLayer::finish()
{
	double period = broadcast_time[myIndex] ;
	recordScalar("Time at last", period );
}

void MacLayer::log(std::string msg)
{
	ev << "[Node " << myIndex << "] - MacLayer: " << msg << endl;
}

MacPkt* MacLayer::createMacPkt(simtime_t length) {
	Signal* s = new Signal(broadcast_time[myIndex], length);
	MacToPhyControlInfo* ctrl = new MacToPhyControlInfo(s);
	MacPkt* res = new MacPkt();
	res->setControlInfo(ctrl);
	res->setKind(BROADCAST_MESSAGE);
	res->setDestAddr(nextReceiver);
	return res;
}
