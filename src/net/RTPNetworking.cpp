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
	#endif

	int status = 0;
	cout << "Main thread initiated" << endl;
	setPriority(QThread::HighestPriority);

	RTPUDPv4TransmissionParams transParams;
	RTPSessionParams sessParams;

	sessParams.SetOwnTimestampUnit(1.0 / 44100.0);
	sessParams.SetAcceptOwnPackets(true);
	sessParams.SetUsePollThread(true);
	sessParams.SetNeedThreadSafety(true);

	transParams.SetPortbase(RTPPort);

	QRTPSession sess;
	status = sess.Create(sessParams, &transParams);
	checkError(status);
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
}
