#ifndef RTP_NETWORK
#define RTP_NETWORK

#include <iostream>
#include <thread>
#include <string>

#include <boost/thread.hpp>

#include <jthread/jthread.h>
#include <jrtplib3/rtpsession.h>
#include <jrtplib3/rtpudpv4transmitter.h>
#include <jrtplib3/rtpipv4address.h>
#include <jrtplib3/rtpsessionparams.h>
#include <jrtplib3/rtperrors.h>
#include <jrtplib3/rtplibraryversion.h>

#include "Buffer.h"
#include "BroadcastAddress.h"

using namespace std;
using namespace jrtplib;

using byte = uint8_t;

enum class AppPacket {LIST_ALL, INFO, ACCEPT, SR, RR, BYE};

class RTPNetworking
{
	private:
		const int RTCPPort = 6004;
		const int RTPPort = 8000;
		RTPSession* session;


	public:
		static const Buffer<AppPacket> requestQ();
		static const Buffer<byte*> networkPackets();

		RTPNetworking();
		setup();
		checkError(int err);
		~RTPNetworking();
};

#endif
