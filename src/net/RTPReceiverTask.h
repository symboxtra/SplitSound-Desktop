#ifndef RTP_RECEIVER
#define RTP_RECEIVER

#include <iostream>
#include <thread>
#include <string>

#include <boost/thread.hpp>

#include "RTPNetworking.h"

using namespace std;
using namespace jrtplib;

using byte = uint8_t;

class RTPReceiverTask
{
	private:
		RTPSession* sess;

	public:
		RTPReceiverTask();
		run();
		~RTPReceiverTask();
};

#endif
