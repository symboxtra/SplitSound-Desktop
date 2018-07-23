#include "RTPNetworking.h"
#include "RTPReceiverTask.h"

RTPNetworking::RTPNetworking()
{
	//boost::thread(&RTPNetworking::setup, this);
}

void RTPNetworking::setup()
{
	try {

		int status = 0;

		/*string broadIP = getBroadcastAddress()[0];
		cout << "Broadcast Address: " << broadIP << endl;
		uint32_t destIP;
		if(inet_pton(AF_INET, broadIP.c_str(), &(destIP)) != 1)
		{
			exit(-1);
		}*/

		RTPUDPv4TransmissionParams transParams;
		RTPSessionParams sessParams;

		sessParams.SetOwnTimestampUnit(1.0 / 44100.0);
		sessParams.SetAcceptOwnPackets(false);
		sessParams.SetUsePollThread(true);
		sessParams.SetNeedThreadSafety(true);

		transParams.SetPortbase(RTPPort);

		status = session->Create(sessParams, &transParams);
		checkError(status);

		// Start sub threads
		RTPReceiverTask* rtpReceiver = new RTPReceiverTask(session);

/*
		status = session->Create(sessParams, &transParams);
		checkError(status);

		RTPIPv4Address broadAddr(destIP, RTPPort);
		status = session->AddDestination(broadAddr);

		checkError(status);

		// Start sub threads
		RTPReceiverTask* rtpReceiver = new RTPReceiverTask(session);
		RTCPReceiverTask* rtcpReceiver = new RTCPReceiverTask(session);
		
		RTPSessionTask* rtpTask = new RTPSessionTask(session);
		RTCPSessionTask* rtcpTask = new RTCPSessionTask(session);*/

	} catch(boost::thread_interrupted& inter){
	}
}


void RTPNetworking::checkError(int err)
{
	if(err < 0)
	{
		cout << "ERROR: " << RTPGetErrorString(err) << endl;
		exit(1);
	}
}

RTPNetworking::~RTPNetworking()
{
}
