#include "RTPReceiverTask.h"

RTPReceiverTask::RTPReceiverTask(SplitSoundRTPSession* session)
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

			if(sess->GotoFirstSourceWithData())
			{
				do {
					RTPPacket* packet = NULL;
					while((packet = sess->GetNextPacket()) != NULL)
					{
						byte* buffer = packet->GetPayloadData();
						//networkPackets.add(buffer);
					}
				} while(sess->GotoNextSourceWithData());
			}
		}
	}catch(boost::thread_interrupted& inter)
	{
	}
}

RTPReceiverTask::~RTPReceiverTask()
{
}
