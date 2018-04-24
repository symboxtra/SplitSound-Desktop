#include "BroadcastAddress.h"

using namespace std;

int main()
{
	for(auto const& addr : getBroadcastAddress())
		cout << "Broadcast Address: " << addr << endl;
}
