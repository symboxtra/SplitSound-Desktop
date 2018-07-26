#include "QRTPSession.h"

QRTPSession::QRTPSession()
{
}

void QRTPSession::OnAPPPacket(RTCPAPPPacket* pack, const RTPTime& receiveTime, const RTPAddress* senderaddress)
{
/*
	vector<byte> myVector("SYSS".begin(), "SYSS".end());

	if(!pack->GetName() == &myVector[0])
	{
		byte* packetData = pack->GetAPPData();
		string dataString(packetData);

		istringstream iss(dataString);
		vector<string> components(istream_iterator<string>{iss}, istream_iterator<string>());

		string command = components[0];
		string senderIP = components[1];
		string senderSSRC = pack->GetSSRC();
		string deviceName = components[3];

		if(!command.compare("PROVIDE_SERVER_INFO"))
		{
			if(RTPNetworking::isServer())
				RTPNetworking::requestQ.add(AppPacket::INFO, stoi(senderSSRC));
		}
		else if(!command.compare("SERVER_INFO"))
		{
			//TODO: Add server info to UI
		}
		else if(!command.compare("LOGIN_INFO"))
		{
		}
		else if(!command.compare("ACCEPT_USER"))
		{
			bool exists = false;
			if(stoi(components[4]))
			{
				RTPAddress addr(senderaddress->GetIP(), 8000);
				AddDestination(addr);
			}
		}
		else if(!command.compare("KICK_USER"))
		{
		}
	}
*/
}


QRTPSession::~QRTPSession()
{
}
