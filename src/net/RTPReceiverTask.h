#ifndef RTP_RECEIVER
#define RTP_RECEIVER

#include <iostream>
#include <thread>
#include <string>

#include <boost/thread.hpp>

#include <jthread/jthread.h>
#include <jrtplib3/rtpsession.h>
#include <jrtplib3/rtppacket.h>
#include <jrtplib3/rtpudpv4transmitter.h>
#include <jrtplib3/rtpipv4address.h>
#include <jrtplib3/rtpsessionparams.h>
#include <jrtplib3/rtperrors.h>
#include <jrtplib3/rtplibraryversion.h>

#include "RTPNetworking.h"

using namespace std;
using namespace jrtplib;

using byte = uint8_t;

class RTPReceiverTask 
{
	private:
		RTPSession* sess;

	public:
		RTPReceiverTask(RTPSession* session)
		{
			sess = session;
			boost::thread(&RTPReceiverTask::run, this);
		}
		
		void run()
		{
			try {

				while(true)
				{
					sess->BeginDataAccess();

					if(sess->GotoFirstSourceWithData())
					{
						do {
							RTPPacket *pack = NULL;
							// receive packets here
							while((pack = sess->GetNextPacket()) != NULL)
							{
								//RTPNetworking::networkingPackets.add(pack->GetPayloadData());
								sess->DeletePacket(pack);
							}

						} while(sess->GotoNextSourceWithData());
					}
				}
			} catch(boost::thread_interrupted& inter) {}
		}
};

#endif
