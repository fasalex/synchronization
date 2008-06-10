#ifndef MACLAYER_H_
#define MACLAYER_H_

#include <omnetpp.h>
#include "MacToPhyInterface.h"
#include "MacToPhyControlInfo.h"
#include "Signal_.h"
#include "MacPkt_m.h"

const int SIZE_OF_NETWORK = 100;
const int clock_const = 1 ;
double temperature = 23 ;
const int frame_length = 11;
int jump ;
double offset = 0 ;

class MacLayer:public BaseModule {
private:
	double rnd ;
	double broadcast_time;
	double frequency ;
	double temp_varr[SIZE_OF_NETWORK];
	int count;
	double Ref ;
	int Period ;
	double clock_drift ;
	int periodCount ;
	int algorithm ;
	double gain ;
	cOutVector output_vec ;
	bool change[];
	double random_start ;
protected:
	MacToPhyInterface* phy;
	
	int dataOut;
	int dataIn;
	int controlIn;
	int controlOut;

	int myIndex;
	int hostCount;
	
	int nextReceiver;
	
	enum {
		BROADCAST_MESSAGE = 10101010,
		CONTROL_MESSAGE = 11111111
	};
	
public:
	//---Omnetpp parts-------------------------------
	virtual void initialize(int stage);	
	MacPkt* createMacPkt(simtime_t length) ;
	virtual void handleMessage(cMessage* msg);
	virtual void sendDown(cMessage* msg) ;
	virtual void analyze_msg();
	virtual void collect_data(cMessage* pkt);
	virtual void finish();
/*	void broadCastPacket();	
	void handleMacPkt(cMessage* pkt);
	void handleTXOver();*/
	void logg(std::string msg);
};

#endif /*MACLAYER_H_*/
