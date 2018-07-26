#ifndef RTP_RECEIVER
#define RTP_RECEIVER

#include <iostream>
#include <thread>
#include <string>

#include <QThread>

#include "RTPNetworking.h"

using namespace std;
using namespace jrtplib;

using byte = uint8_t;

class RTPReceiverTask : public QThread
{
	private:
		QRTPSession* sess;
		void run();

	public:
		RTPReceiverTask(QRTPSession* session);
		~RTPReceiverTask();
};

#endif
