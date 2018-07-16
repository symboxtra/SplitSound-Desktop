#include "RTPNetworking.h"

RTPNetworking::RTPNetworking()
{
	boost::thread(&RTPNetworking::setup, this);
}

void RTPNetworking::setup()
{
	try {

		RTPUDPv4TransmissionParams transparams;
		RTPSessionParams sessParams;

		sessParams.SetOwnTimestampUnit(1.0 / 44100.0);
		sessParams.SetAcceptOwnPackets(false);
		transParams.SetPortbase(RTPPort);
		
		status = session->Create(sessParams, &transParams);
		checkError(status);

		// Start sub threads
		RTPReceiverTask* rtpReceiver = new RTPReceiverTask(session);
		RTCPReceiverTask* rtcpReceiver = new RTCPReceiverTask(session);
		
		RTPSessionTask* rtpTask = new RTPSessionTask(session);
		RTCPSessionTask* rtcpTask = new RTCPSessionTask(session);

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
