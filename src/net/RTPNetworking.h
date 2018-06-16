#include <iostream>
#include <thread>
#include <string>

using namespace std;
using namespace jrtplib;

class RTPNetworking
{

	private:
		final int RTPPort = 6004;
		final int RTCPPort = 8000;

	public:
		RTPNetworking()
		{
			tThread = boost::thread(&RTPNetworking::setup, this);
		}
		
		void setup()
		{
			try {

				int status;

				RTPUDPv4TransmissionParams transparams;
				RTPSessionsParams sessParams;
				RTPSession sess;

				sessParams.SetOwnTimeStampUnit(1.0 / 44100.0);
				sessParams.SetAcceptOwnPackets(true);
				transParams.setPortbase(RTPPort);

				status = sess.Create(sessParams, &transParams);
				checkError(status);



				
			}catch(boost::thread_interrupted& inter){
				
			}catch(std::exception& e){
			}
		}

		void checkError(int err)
		{
			if(err < 0)
			{
				cout << "ERROR: " << RTPGetErrorString(err) << endl;
				exit(-1);
			}
		}
}
