#include "RTPReceiverTask.h"

RTPReceiverTask::RTPReceiverTask(QRTPSession* session)
{
	sess = session;
}

void RTPReceiverTask::run()
{
	int count = 0;
	cout << "RTPReceiver initiated";

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
					cout << "PacketInfo: SSRC-" << packet->GetSSRC() << " Count-" << count++ << endl;
				}
			} while(sess->GotoNextSourceWithData());
		}
	}
}

RTPReceiverTask::~RTPReceiverTask()
{
}
