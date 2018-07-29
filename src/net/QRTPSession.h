#ifndef QRTPSESSION_H
#define QRTPSESSION_H

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
#include <jrtplib3/rtcpcompoundpacket.h>
#include <jrtplib3/rtcppacket.h>

using namespace std;
using namespace jrtplib;

using byte = uint8_t;

class QRTPSession : public QObject, public RTPSession
{
	Q_OBJECT

	public:
		int totalParticipants;

		QRTPSession();
		~QRTPSession();
		int getNumParticipants();

	private:
		int count = 0;
		void OnAPPPacket(RTCPAPPPacket* pack, const RTPTime& receiveTime, const RTPAddress* senderaddress);
		void OnRTCPCompoundPacket(RTCPCompoundPacket* pack, const RTPTime& receiveTime, const RTPAddress* senderaddress);	
		void OnRTPPacket(RTPPacket* pack, const RTPTime& receiveTime, const RTPAddress* senderAddress);
};

#endif // QRTPSESSION_H
