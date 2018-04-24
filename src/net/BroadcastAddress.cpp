#include "BroadcastAddress.h"

using namespace std;

int main()
{
	
	vector<string>::iterator it;

	vector<string> test = getBroadcastAddress();
	for (it = test.begin();it != test.end();it++)
	{
		cout << "Broadcast Address: " << *it << endl;
	}

	cout << "Hi" << endl;
}
