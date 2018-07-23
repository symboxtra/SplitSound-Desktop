#include "RTCPSessionTask.h"

RTCPSessionTask::RTCPSessionTask(RTPSession* session)
{
	sess = session;
	boost::thread(&RTCPSessionTask::run, this);
}

RTCPSessionTask::run()
{
	try {
		while(sess->IsActive())
		{
			if(RTPNetworking::requestQ.isEmpty())
			{
				string data = "";
				int appType = 0;

				pair<AppPacket, int> appPair = RTPNetworking::requestQ.getNext();
				AppPacket task = appPair.first;

				switch(task)
				{
					case LIST_ALL:
						appType = 0;
						data = "PROVIDE_SERVER_INFO " + RTPNetworking::deviceIP + " " + session->GetLocalSSRC() + " " + session->GetCNAME();
						break;
					case INFO:
						appType = 1;
						data = "SERVER_INFO " + RTPNetworking::deviceIP + " " + session->GetLocalSSRC() + " " + session->GetCNAME() + " UNLOCKED " + numParticipants; //TODO: Determine locked/unlocked from server settings
						break;
					case LOGIN:
						appType = 2;
						//TODO: Get username from settings
						data = "LOGIN_INFO " + RTPNetworking::deviceIP + " " + sess->GetLocalSSRC() + " " + session->GetCName() + " " + "password"; //TODO: encrypt password before sending
						break;
					case ACCEPT:
						appType = 3;
						data = "ACCEPT_USER " + RTPNetworking::deviceIP + " " + session->GetLocalSSRC() + " " + session->GetCNAME() + "1/0"; //TODO: Accept or deny based on password from client 
						break;
					case KICK:
						break;	
				}

				while(data.length() % 4 != 0)
					data += " ";
			}
		}
	}catch(boost::thread_interrupted& inter){
	}
}

RTCPSessionTask::~RTCPSessionTask()
{
}
