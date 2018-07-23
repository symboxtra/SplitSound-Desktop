#ifndef RTP_SESSION
#define RTP_SESSION

#include <iostream>
#include <thread>
#include <string>
#include <vector>

#include <boost/thread.hpp>

#include <jthread/jthread.h>
#include <jrtplib3/rtpsession.h>
#include <jrtplib3/rtpudpv4transmitter.h>
#include <jrtplib3/rtpipv4address.h>
#include <jrtplib3/rtpsessionparams.h>
#include <jrtplib3/rtperrors.h>
#include <jrtplib3/rtplibraryversion.h>

#include "RTPNetworking.h"

using namespace std;
using namespace jrtplib;
using byte = uint8_t;

class SplitSoundRTPSession : public RTPSession
{
	public:
		SplitSoundRTPSession();
		void OnAPPPacket(RTCPAPPPacket* pack, const RTPTime& receiveTime, const RTPAddress* senderaddress);
		~SplitSoundRTPSession();
};

#endif
