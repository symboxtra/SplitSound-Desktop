#ifndef RTP_NETWORK
#define RTP_NETWORK


//#include "BroadcastAddress.h"
#include <iostream>
#include <thread>
#include <mutex>
#include <string>

#include <jthread/jthread.h>
#include <jrtplib3/rtpsession.h>
#include <jrtplib3/rtpudpv4transmitter.h>
#include <jrtplib3/rtpipv4address.h>
#include <jrtplib3/rtpsessionparams.h>
#include <jrtplib3/rtperrors.h>
#include <jrtplib3/rtplibraryversion.h>
#include <jrtplib3/rtppacket.h>

#include <QThread>

#include "Buffer.h"
#include "QRTPSession.h"
#include "RTPReceiverTask.h"

using namespace std;
using namespace jrtplib;

using byte = uint8_t;

enum class AppPacket {LIST_ALL, INFO, ACCEPT, SR, RR, BYE};

class RTPNetworking : public QThread
{
	Q_OBJECT

	private:
		const int RTCPPort = 6004;
		const int RTPPort = 8000;
		QRTPSession session;
		void run();

	public:
		static const Buffer<AppPacket> requestQ;
		static const Buffer<byte*> networkPackets;

		RTPNetworking();
		void checkError(int err);
		~RTPNetworking();
};

#endif
