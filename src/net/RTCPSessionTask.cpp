#include "RTCPSessionTask.h"

RTCPSessionTask::RTCPSessionTask(QRTPSession *session)
{
    sess = session;
}

void RTCPSessionTask::run()
{

    while (sess->IsActive())
    {
        if (RTPNetworking::requestQ().isEmpty())
        {
            string data = "";
            byte appType = 0;

            pair<AppPacket, int> appPair = RTPNetworking::requestQ().getNext();
            AppPacket task = appPair.first;

            switch (task)
            {
                case AppPacket::LIST_ALL:
                    appType = 0;
                    data = "Test hi";
                    //data = "PROVIDE_SERVER_INFO " + deviceIP + " " + sess->GetLocalSSRC() + " " + sess->GetCNAME();
                    break;
                case AppPacket::INFO:
                    appType = 1;
                    data = "Test hu";
                    //data = "SERVER_INFO " + deviceIP + " " + sess->GetLocalSSRC() + " " + sess->GetCNAME() + " UNLOCKED " + sess->getNumParticipants(); //TODO: Determine locked/unlocked from server settings and number of participants
                    break;
                /*case AppPacket::LOGIN:
                    break;
                case AppPacket::ACCEPT:
                    break;
                case AppPacket::KICK:
                    break;*/            
            }

            /*string appName("SYSS")
            uint8_t* p = reinterpret_cast<const uint8_t*>(appName.c_str());

            sess->SendRTCPAPPPacket(appType, p, static_cast<void*>(&data), data.length);*/
        }
    }
}

RTCPSessionTask::~RTCPSessionTask()
{
}