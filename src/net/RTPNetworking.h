#ifndef RTP_NETWORKING
#define RTP_NETWORKING

#include <iostream>
#include <thread>
#include <string>
#include <boost/thread.hpp>

#include "Buffer.h"

using namespace std;

enum class AppPacket {LIST_ALL, INFO, LOGIN, ACCEPT, SR, RR, BYE};

class RTPNetworking
{

	private:
		const int RTPPort = 6004;
		const int RTCPPort = 8000;



	public:
		static const Buffer<AppPacket> requestQ();

		RTPNetworking()
		{
			boost::thread(&RTPNetworking::setup, this);
		}
		
		void setup()
		{
			try {

				int status;

			/*	RTPUDPv4TransmissionParams transparams;
				RTPSessionsParams sessParams;
				RTPSession sess;

				sessParams.SetOwnTimeStampUnit(1.0 / 44100.0);
				sessParams.SetAcceptOwnPackets(true);
				transParams.setPortbase(RTPPort);

				status = sess.Create(sessParams, &transParams);
				checkError(status);
			*/


				
			}catch(boost::thread_interrupted& inter){
				
			}catch(std::exception& e){
			}
		}

		void checkError(int err)
		{
			if(err < 0)
			{
				//cout << "ERROR: " << RTPGetErrorString(err) << endl;
				exit(-1);
			}
		}
};

#endif
