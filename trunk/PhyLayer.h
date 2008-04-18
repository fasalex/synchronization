#ifndef PhyLayer_H_
#define PhyLayer_H_

#include <BasePhyLayer.h> 


class PhyLayer:public BasePhyLayer{
private:
	class TestDecider:public Decider {
	protected:
		int myIndex;
		std::map<Signal*, int> currentSignals;
		
		enum {
			FIRST,
			HEADER_OVER,
			SIGNAL_OVER
		};
	public:
		TestDecider(DeciderToPhyInterface* phy, int myIndex):
			Decider::Decider(phy), myIndex(myIndex) {
		}
		
		virtual simtime_t processSignal(AirFrame* frame) {
			Signal* s = &frame->getSignal();
			
			std::map<Signal*, int>::iterator it = currentSignals.find(s);
			if(it == currentSignals.end()) {
				currentSignals[s] = HEADER_OVER;
				
				log("First processing of this signal. Scheduling it to end of header to decide if Signal should be received.");
				return s->getSignalStart() + 0.10 * s->getSignalLength();
			}
			
			switch(it->second) {
			case HEADER_OVER:
				log("Second receive of a signal from Phy - Deciding if packet should be received - Let's try to receive it.");
				it->second = SIGNAL_OVER;
				return s->getSignalStart() + s->getSignalLength();
				
			case SIGNAL_OVER:
				log("Last receive of signal from Phy - Deciding if the packet could be received correctly - Let's say its correct.");
				phy->sendUp(frame, 1);
				currentSignals.erase(it);
				return -1;
			default:
				break;
			}
			
			//we should never get here!
			return 0;
		}
		
		void log(std::string msg) {
			ev << "[Node " << myIndex << "] - PhyLayer(Decider): " << msg << endl;
		}
	};
	
	class TestAnalogueModel:public AnalogueModel {
	public:
		double att;
		int myIndex;
		std::string myName;
		
		TestAnalogueModel(std::string name, double attenuation, int myIndex):
			att(attenuation), myName(name), myIndex(myIndex) {}
		
		void filterSignal(Signal& s) {
			log("Filtering signal.");
		}
		
		void log(std::string msg) {
			ev << "[Node " << myIndex << "] - PhyLayer(" << myName << "): " << msg << endl;
		}
	};
protected:
	int myIndex;
	int dataOut;
	int dataIn;
	int In ;
	virtual AnalogueModel* getAnalogueModelFromName(std::string name, ParameterMap& params);		
		
	virtual Decider* getDeciderFromName(std::string name, ParameterMap& params);
	
public:
	virtual void initialize(int stage);
	
	void handleAirFrame(cMessage* msg);
	void handleAirFrameReceive(AirFrame *pkt);
	AirFrame *encapsMsg(cMessage *msg);
	void sendUp(AirFrame* frame, DeciderResult result);
	void sendMacPktUp(cMessage* pkt);
	void sendMessageDown(AirFrame *pkt);
	void handleUpperMessage(cMessage* msg);
	void handleUpperControlMessage(cMessage* msg);
	void handleSelfMessage(cMessage* msg);
	virtual void handleMessage(cMessage* msg);
	simtime_t calculatePropagationDelay(AirFrame* frame);
	
	void log(std::string msg);
};

#endif /*PhyLayer_H_*/
