#include "RTCPSessionTask.h"

RTCPSessionTask::RTCPSessionTask(QRTPSession* session)
{
    sess = session;
}

void RTCPSessionTask::run()
{
    /*
    while(sess->IsActive())
    {
        string data = "";
        int appType = 0;

        pair<AppPacket, int> appPair = RTPNetworking::requestQ().getNext();
        AppPacket task = appPair.first;

        switch(task)
        {
            case AppPacket::LIST_ALL:
                appType = 0;
                data = "PROVIDE_SERVER_INFO " + deviceIP + " " + sess->GetLocalSSRC() + " " + sess->GetCNAME();
                break;
            case AppPacket::INFO:
                appType = 1;
                data = "SERVER_INFO " + deviceIP + " " + sess->GetLocalSSRC() + " " + sess->GetCNAME() + " UNLOCKED " + sess->getNumParticipants(); //TODO: Determine locked/unlocked from server settings and number of participants
                break;
            case AppPacket::LOGIN:
                break;
            case AppPacket::ACCEPT:
                break;
            case AppPacket::KICK:
                break;
        }
    }*/
}

RTCPSessionTask::~RTCPSessionTask()
{

}