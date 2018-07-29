#ifndef RTCPSESSION_H
#define RTCPSESSION_H

#include <string>
#include <iostream>

#include <QThread>

#include "RTPNetworking.h"

using namespace std;
using namespace jrtplib;

using byte = uint8_t;

class RTCPSessionTask : public QThread
{
    Q_OBJECT

    private:
        QRTPSession* sess;

        void run();

    public:
        RTCPSessionTask(QRTPSession* sess);
        ~RTCPSessionTask();
};

#endif // RTCPSESSION_H