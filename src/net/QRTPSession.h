#ifndef QRTP
#define QRTP

#include <vector>
#include <iostream>
#include <sstream>

#include <QObject>

#include <jthread/jthread.h>
#include <jrtplib3/rtpsession.h>
#include <jrtplib3/rtpipv4address.h>
#include <jrtplib3/rtperrors.h>
#include <jrtplib3/rtcpapppacket.h>
#include <jrtplib3/rtppacket.h>

using namespace std;
using namespace jrtplib;

using byte = uint8_t;

class QRTPSession : public QObject, public jrtplib::RTPSession
{
	Q_OBJECT

	public:
		QRTPSession();
		~QRTPSession();
		void OnAPPPacket(RTCPAPPPacket* pack, const RTPTime& receiveTime, const RTPAddress* senderaddress);	
		void OnRTPPacket(RTPPacket* pack, const RTPTime& receiveTime, const RTPAddress* senderAddress);

	private:
		int count;
};

#endif
