#ifndef RTP_NETWORK_H
#define RTP_NETWORK_H

#include <iostream>
#include <utility>
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
//#include "BroadcastAddress.h"
#include "QRTPSession.h"

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

		RTPUDPv4TransmissionParams transparams;
		RTPSessionParams sessparams;

		void run();

	public:
		static Buffer<byte*>& networkPackets() {static Buffer<byte*> np; return np;}
		static Buffer<AppPacket>& requestQ() {static Buffer<AppPacket> rq; return rq;}

		RTPNetworking();
		void checkError(int err);
		~RTPNetworking();
};

#endif // RTP_NETWORK_H
