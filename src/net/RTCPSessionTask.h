#ifndef RTCP_SENDER
#define RTCP_SENDER

#include <string>
#include <thread>
#include <iostream>

#include <boost/thread.hpp>

#include "RTPNetworking.h"

class RTCPReceiverTask
{
	private:
		RTPSession* sess;
		int numParticipants;
	
	public:
		RTCPSessionTask();
		run();
		~RTCPSessionTask();
};

#endif
