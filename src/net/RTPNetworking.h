#ifndef RTP_NETWORKING
#define RTP_NETWORKING

#include <iostream>
#include <thread>
#include <string>

#include <boost/thread.hpp>

#include <jthread/jthread.h>
#include <jrtplib3/rtpsession.h>
#include <jrtplib3/rtpudpv4transmitter.h>
#include <jrtplib3/rtpipv4address.h>
#include <jrtplib3/rtpsessionparams.h>
#include <jrtplib3/rtperrors.h>
#include <jrtplib3/rtplibraryversion.h>

#include "Buffer.h"
#include "RTPReceiverTask.h"

using namespace std;
using namespace jrtplib;

using byte = uint8_t;

enum class AppPacket {LIST_ALL, INFO, LOGIN, ACCEPT, SR, RR, BYE};

class RTPNetworking
{

	private:
		const int RTPPort = 6004;
		const int RTCPPort = 8000;
		RTPSession* session;
	public:
		static const Buffer<AppPacket> requestQ();
		static Buffer<byte[]> networkingPackets();

		RTPNetworking()
		{
			boost::thread(&RTPNetworking::setup, this);
		}
		
		void setup()
		{
			try {
			
				int status;

				RTPUDPv4TransmissionParams transParams;
				RTPSessionParams sessParams;

				sessParams.SetOwnTimestampUnit(1.0 / 44100.0);
				sessParams.SetAcceptOwnPackets(true);
				transParams.SetPortbase(RTPPort);

				status = session->Create(sessParams, &transParams);
				checkError(status);

				RTPReceiverTask* receiver = new RTPReceiverTask(session);


			
				
			}catch(boost::thread_interrupted& inter){
				
			}catch(std::exception& e){
			}
		}

		void checkError(int err)
		{
			if(err < 0)
			{
				cout << "ERROR: " << RTPGetErrorString(err) << endl;
				exit(-1);
			}
		}
};

#endif
