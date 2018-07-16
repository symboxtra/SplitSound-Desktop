#include "RTPReceiverTask.h"

RTPReceiverTask::RTPReceiverTask(RTPSession* session)
{
	sess = session;
	boost::thread(&RTPReceiverTask::run, this);
}

void RTPReceiverTask::run()
{
	try {
		while(sess->IsActive())
		{
			sess->BeginDataAccess();

			if(sess.GotoFirstSourceWithData())
			{
				do {
					RTPPacket *pack = NULL;
					while((pack = sess.GetNextPacket()) != NULL)
					{
						byte* buffer = pack->GetPayloadData();
						RTPNetworking::networkPackets().add(buffer);
					}
				} while(sess.GotoNextSourceWithData());
			}
		}
	}catch(boost::thread_interrupted& inter)
	{
	}
}

RTPReceiverTask::~RTPReceiverTask()
{
}
