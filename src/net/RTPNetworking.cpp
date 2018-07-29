#include "RTPNetworking.h"

RTPNetworking::RTPNetworking()
{
}

void RTPNetworking::run()
{
	/*
	string broadIP = getBroadcastAddress()[0];
	cout << "Broadcast Address: " << broadIP << endl;
	uint32_t destIP;
	if(inet_pton(AF_INET, broadIP.c_str(), &(destIP)) != 1)
	{
		exit(-1);
	}*/

	#ifdef RTP_SOCKETTYPE_WINSOCK
		WSADATA dat;
		WSAStartup(MAKEWORD(2, 2), &dat);
	#endif // RTP_SOCKETTYPE_WINSOCK

	int status = 0;

	QRTPSession sess;
	
	sessparams.SetOwnTimestampUnit(1.0 / 44100.0);
	sessparams.SetAcceptOwnPackets(true);
	sessparams.SetNeedThreadSafety(true);
	sessparams.SetUsePollThread(true);

	transparams.SetPortbase(8000);

	status = sess.Create(sessparams, &transparams);
	checkError(status);

	while (sess.IsActive())
	{
		RTPTime::Wait(RTPTime(0, 10000));
	}
}

void RTPNetworking::checkError(int err)
{
	if(err < 0)
	{
		cout << "NETWORK_ERROR: " << RTPGetErrorString(err) << endl;
		exit(1);
	}
}

RTPNetworking::~RTPNetworking()
{
	#ifdef RTP_SOCKETTYPE_WINSOCK
		WSACleanup();
	#endif // RTP_SOCKETTYPE_WINSOCK
}
