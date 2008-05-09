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
		Period[myIndex] = 0 ;
		count[myIndex] = 0;
		Period[myIndex] = 0 ;
		dataOut = findGate("lowerGateOut");
		dataIn = findGate("lowerGateIn");
		controlOut = findGate("lowerControlOut");
		controlIn = findGate("lowerControlIn");
		random_start = (double) parentModule()->par("start_time") / hostCount;
		if(random_start < 0.5)
		frequency[myIndex] = clock_const + clock_const*random_start ;
		else 
		frequency[myIndex] = clock_const - clock_const*random_start ;
		
	} 
	else if(stage == 1) {
		broadcast_time[myIndex] = parentModule()->par("start_time");
		MacPkt* pkt = createMacPkt(frame_length);
		scheduleAt(broadcast_time[myIndex], pkt);

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
		output_vec.record(broadcast_time[myIndex]*1000000) ;			
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
	double offset = 0 ;
	int medium_value = (int) neigh / 2 ;
	double median = 0.5 *(temp_varr[myIndex][medium_value - 1] + temp_varr[myIndex][medium_value]) ;
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
		double tempp[SIZE_OF_NETWORK][SIZE_OF_NETWORK] ;
		double sum = 0 ;

		for(int af = 0 ; af < neigh ; af ++) {
			tempp[myIndex][af] = abs(temp_varr[myIndex][af]-median);
			sum = sum + tempp[myIndex][af] ;
		}
		if(sum==0)
			offset = 0 ;
		else{
		for (int m=0; m < neigh; m++){
			 if(neigh != 1){
		         weight[m]= (1 - tempp[myIndex][m]/sum)/(neigh-1) ; 
			 weight[m] = sqrt(weight[m]) ;
			 }else
			 weight[m] = 1 ;
		  	 offset = offset + ( temp_varr[myIndex][m] * weight[m] ) ;
		}
		}
		offset = offset * gain ;
		break;}
	case 4:{
		double weight[SIZE_OF_NETWORK];
		double tempp[SIZE_OF_NETWORK][SIZE_OF_NETWORK] ;
		double sum = 0 ;

		for(int af = 0 ; af < neigh ; af ++) {
			tempp[myIndex][af] = abs(temp_varr[myIndex][af]-median);
			sum = sum + tempp[myIndex][af] ;
		}
		if(sum==0)
			offset = 0 ;
		else{
		for (int m=0; m < neigh; m++){
			 if(neigh != 1){
		         weight[m]= (1 - tempp[myIndex][m]/sum)/(neigh-1) ; 
			 }else
			 weight[m] = 1 ;
		  	 offset = offset + (temp_varr[myIndex][m] * weight[m]) ;
		}
		}
		offset = offset * gain ;
		break;}
	default:
		offset = 0;
		break;
	}

	if(Period[myIndex]%jump != 0)
	offset = 0 ;
	broadcast_time[myIndex] = broadcast_time[myIndex] - gain*offset + frequency[myIndex] ;
	
        MacPkt* pkt = createMacPkt(frame_length);
	scheduleAt(broadcast_time[myIndex],pkt) ;
	count[myIndex] = 0 ;
	cMessage *ctrl = new cMessage("bla bla");
	Ref[myIndex] = Ref[myIndex] + clock_const ;
	Period[myIndex]++ ;
	ctrl->setKind(CONTROL_MESSAGE);
	scheduleAt(Ref[myIndex],ctrl);
}
void MacLayer::collect_data(cMessage *pkt)
{	
	clock_drift = (temperature - 25 )* exp(-6) * 0.5 / 20 ;
	temp_varr[myIndex][count[myIndex]] = broadcast_time[myIndex] - simTime() +  clock_drift;
	count[myIndex]++;
	log("Recording the simulation values");
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
