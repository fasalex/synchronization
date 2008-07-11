#include "PhyLayer.h"
#include "MacToPhyControlInfo.h"
#include "PhyToMacControlInfo.h"
#include "BaseWorldUtility.h"

Define_Module(PhyLayer);

void PhyLayer::initialize(int stage) {
	
	//has to be done before decider and analogue models are initialized
	if(stage == 0) 
		myIndex = parentModule()->par("id");
	
	//call BasePhy's initialize
	BasePhyLayer::initialize(stage);
	
	if(stage == 0) {
		
	} else if(stage == 1) {
		
	}
}

void PhyLayer::handleMessage(cMessage* msg) {	
	bubble("message received ") ;
		//self messages	
	if(msg->isSelfMessage()) {
		handleSelfMessage(msg);
	
	//MacPkts <- MacToPhyControlInfo
	} else if(msg->arrivalGateId() == upperGateIn) {
		handleUpperMessage(msg);
		
	//controlmessages 
	} else if(msg->arrivalGateId() == upperControlIn) {
		handleUpperControlMessage(msg);
		
	//AirFrames
	} else if(msg->kind() == 22003){
		handleAirFrame(msg);
		
	//unknown message
	} else {
		ev << msg->kind() << endl ;
		log("Unknown message received.");
	}

}
	
void PhyLayer::handleAirFrame(cMessage* msg)
{	
	log("Handling the messages received from Neighbour Nodes ...") ;
	AirFrame* frame = static_cast<AirFrame*>(msg) ;
// Sending the signal to be filtered to the analoge module .....
	filterSignal(frame->getSignal());
// To the decider if there is one ...
	if(decider)
		handleAirFrameReceive(frame);		

}
void PhyLayer::handleAirFrameReceive(AirFrame *frame){

/*	Signal& signal = frame-> getSignal() ;
	simtime_t nextHandleTime = decider->processSignal(frame);
	simtime_t signalEndTime = signal.getSignalStart() + frame->getDuration();

	if(simTime() >= signalEndTime){
		sendUp(frame, 1);
		channelInfo.removeAirFrame(frame);
		return ;
	}
	if(nextHandleTime < 0){
		nextHandleTime = signalEndTime ;
	}else if ( nextHandleTime < simTime() || nextHandleTime > signalEndTime){
		opp_error("Invalid next handle Time returned by Decider. Expected value between current simulation time (%.2f) and end of signal (%.2f) but got %.2f", simTime() , signalEndTime , nextHandleTime);
	}
*/
	
	sendUp(frame, true);
	delete frame ;
}

void PhyLayer::sendUp(AirFrame* frame, DeciderResult result) {
	simtime_t delay;
	bool propagationDelay = par("usePropagationDelay") ;
	if(propagationDelay)
		delay = calculatePropagationDelay(frame);
	else 
		delay = 0;
	cMessage* packet = frame->decapsulate() ;
	assert(packet);
	PhyToMacControlInfo* ctrlInfo = new PhyToMacControlInfo(result);
	packet->setControlInfo(ctrlInfo);
	packet->setTimestamp(delay);
	packet->setKind(0);
	sendMacPktUp(packet);
}
void PhyLayer::sendMacPktUp(cMessage* packet){
	send(packet, upperGateOut);
}
void PhyLayer::sendMessageDown(AirFrame *pkt)
{
	sendToChannel(pkt, 0);	
}
void PhyLayer::handleUpperControlMessage(cMessage* msg)
{
	log("handle control message ");
}
void PhyLayer::handleUpperMessage(cMessage* msg)
{
	AirFrame* frame = encapsMsg(msg);
	log("Broadcasting Messages to Neighbours ..") ;
	sendMessageDown(frame) ;
}
void PhyLayer::handleSelfMessage(cMessage* msg) 
{
	log(" Handle self message ");
}
void PhyLayer::log(std::string msg) {
	ev << "[Node " << myIndex << "] - PhyLayer: " << msg << endl;
}

AnalogueModel* PhyLayer::getAnalogueModelFromName(std::string name, ParameterMap& params) {
	cPar par = params["attenuation"];
	return new TestAnalogueModel(name, par.doubleValue(), myIndex);
}
		
Decider* PhyLayer::getDeciderFromName(std::string name, ParameterMap& params) {
		
	return new TestDecider(this, myIndex);
}
simtime_t PhyLayer::calculatePropagationDelay(AirFrame* frame)
{
	const Signal& s = frame->getSignal() ;
	Move senderPos = s.getMove() ;	
	simtime_t actualTime = simTime() ;
	double distance = senderPos.getPositionAt(actualTime).distance(move.getPositionAt(actualTime));
	double delay = distance / BaseWorldUtility::speedOfLight;
	return delay ;
}
AirFrame *PhyLayer::encapsMsg(cMessage *msg)
{	
	// the cMessage passed must be a MacPacket... but no cast needed here
	// ...and must always have a ControlInfo attached (contains Signal)

	cPolymorphic* ctrlInfo = msg->removeControlInfo();
	assert(ctrlInfo);
	
	MacToPhyControlInfo* macToPhyCI = static_cast<MacToPhyControlInfo*>(ctrlInfo);
	
	// Retrieve the pointer to the Signal-instance from the ControlInfo-instance.
	// We are now the new owner of this instance.
	Signal* s = macToPhyCI->retrieveSignal();
	
	
	// delete the Control info
	delete macToPhyCI;
	macToPhyCI = 0;
	ctrlInfo = 0;
	
	// make sure we really obtained a pointer to an instance
	assert(s);
	
	// put host move pattern to Signal
	s->setMove(move);
	
	// create the new AirFrame
	AirFrame* frame = new AirFrame(0, AIR_FRAME);
	
	// set the members
	frame->setDuration(s->getSignalLength());
	// copy the signal into the AirFrame
	frame->setSignal(*s);
	
	// pointer and Signal not needed anymore
	delete s;
	s = 0;

	// TO TEST: check if id is really unique
	frame->setId(world->getUniqueAirFrameId());
	frame->encapsulate(msg);
	// --- from here on, the AirFrame is the owner of the MacPacket ---
	msg = 0;
	
	
	return frame;
}
