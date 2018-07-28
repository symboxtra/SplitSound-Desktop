#include "QRTPSession.h"

QRTPSession::QRTPSession()
{
}

void QRTPSession::OnAPPPacket(RTCPAPPPacket* pack, const RTPTime& receiveTime, const RTPAddress* senderaddress)
{
	//string appName(pack->GetName()); 
	string appName(reinterpret_cast<char*>(pack->GetName()));
	
	if(!appName.compare("SYSS"))
	{	
		// Convert byte array to a string vector
		string dataString(reinterpret_cast<char*>(pack->GetAPPData()));
		stringstream ss(dataString);
		istream_iterator<string> begin(ss);
		istream_iterator<string> end;
		vector<string> components(begin, end);

		string command = components[0];
		string senderIP = components[1];
		string senderSSRC = to_string(pack->GetSSRC());
		string deviceName = components[3];

		if(!command.compare("PROVIDE_SERVER_INFO"))
		{
			//if(RTPNetworking::isServer())
				//RTPNetworking::requestQ.add(AppPacket::INFO, stoi(senderSSRC));
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
				//RTPAddress addr(((RTPIPv4Address*)senderaddress)->GetIP(), 8000);
				//AddDestination(addr);
			}
		}
		else if(!command.compare("KICK_USER"))
		{
		}
	}
}

void QRTPSession::OnRTPPacket(RTPPacket* pack, const RTPTime& receiveTime, const RTPAddress* senderAddress)
{
	byte* buffer = pack->GetPayloadData();
	cout << count++ << endl;
}

QRTPSession::~QRTPSession()
{
}
