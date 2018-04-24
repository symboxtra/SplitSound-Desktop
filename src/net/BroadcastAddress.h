#ifndef BROADCASTADDRESS
#define BROADCASTADDRESS

#include <vector>
#include <iostream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>

using namespace std;

#ifdef __linux__

#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <ifaddrs.h>

string getDeviceIP()
{
	const char* google_server = "8.8.8.8";
	int dns_port = 53;

	struct sockaddr_in serv;
	int sock = socket(AF_INET, SOCK_DGRAM, 0);
	if(sock < 0)
		perror("Socket error");

	memset(&serv, 0, sizeof(serv));
	serv.sin_family = AF_INET;
	serv.sin_addr.s_addr = inet_addr(google_server);
	serv.sin_port = htons(dns_port);

	int err = connect(sock, (const struct sockaddr*)&serv, sizeof(serv));

	struct sockaddr_in name;
	socklen_t namelen = sizeof(name);

	err = getsockname(sock, (struct sockaddr*)&name, &namelen);

	char buffer[100];
	const char* p = inet_ntop(AF_INET, &name.sin_addr, buffer, 100);

	string ip = "";
	if(p != NULL)
		ip = string(buffer);
	else
	{
		ip = "ERROR";
	}
	close(sock);
	return ip;
}

vector<pair<string, string>> getSubnetMask()
{
	vector<pair<string, string>> ipSubnetList;

	struct ifaddrs *ifap, *ifa;
	struct sockaddr_in *sa;

	string addr;
	vector<string> list;

	getifaddrs(&ifap);
	for(ifa = ifap;ifa;ifa = ifa->ifa_next)
	{
		if(ifa->ifa_addr->sa_family==AF_INET)
		{
			sa = (struct sockaddr_in*) ifa->ifa_netmask;
			addr = string(inet_ntoa(sa->sin_addr));

			sa = (struct sockaddr_in*)ifa->ifa_addr;

			ipSubnetList.push_back(make_pair(string(inet_ntoa(sa->sin_addr)), addr));
		}
	}
	freeifaddrs(ifap);
	return ipSubnetList;
}

vector<string> getBroadcastAddress()
{
	struct in_addr host, subnet, broadcast;
	char broadcastAddr[INET_ADDRSTRLEN];

	vector<pair<string, string>>::iterator it;
	vector<pair<string, string>> ipSubnetList = getSubnetMask();
	vector<string> broadcastList;


	for (it = ipSubnetList.begin();it != ipSubnetList.end();it++)
	{

		// Remove IP shells on the network
		if (!it->first.compare("0.0.0.0"))continue;

		// Remove localhost
		if(!it->first.compare("127.0.0.1"))continue;

		if(inet_pton(AF_INET, it->first.c_str(), &host) && inet_pton(AF_INET, it->second.c_str(), &subnet))
			broadcast.s_addr = host.s_addr | ~subnet.s_addr;
		else
		{
			cout << "Error: Could not convert IP to binary" << endl;
			exit(1);
		}

		if(inet_ntop(AF_INET, &broadcast, broadcastAddr, INET_ADDRSTRLEN) != NULL)
			broadcastList.push_back(string(broadcastAddr));
		else
		{
			cout << "Error: Could not convert broadcast to IP" << endl;
			exit(1);
		}
	}

	return broadcastList;
}

#elif _WIN32

#include <winsock2.h>
#include <Ws2tcpip.h>
#include <Iphlpapi.h>

#define MALLOC(x) HeapAlloc(GetProcessHeap(), 0, (x))
#define FREE(x) HeapFree(GetProcessHeap(), 0, (x))
#define INET_ADDRSTRLEN 16

/*
 * Gets the IP address of all the network connections of local machine
 */
vector<pair<string, string>> getDeviceIP()
{
	// Create variables for storage and system calls
	vector<pair<string, string>> ipSubnetList;
	PIP_ADAPTER_INFO pAdapterInfo = (IP_ADAPTER_INFO *)MALLOC(sizeof(IP_ADAPTER_INFO));
	PIP_ADAPTER_INFO pAdapter = NULL;
	DWORD dwRetVal = 0;
	ULONG ulOutBufLen = sizeof(IP_ADAPTER_INFO);

	if (pAdapterInfo == NULL) 
	{
		cout << "Error allocating memory needed to call GetAdaptersinfo" << endl;
		return ipSubnetList;
	}
	// Make an initial call to GetAdaptersInfo to get
	// the necessary size into the ulOutBufLen variable
	if (GetAdaptersInfo(pAdapterInfo, &ulOutBufLen) == ERROR_BUFFER_OVERFLOW) 
	{
		FREE(pAdapterInfo);
		pAdapterInfo = (IP_ADAPTER_INFO *)MALLOC(ulOutBufLen);
		if (pAdapterInfo == NULL) 
		{
			cout << "Error allocating memory needed to call GetAdaptersinfo" << endl;
			return ipSubnetList;
		}
	}

	// Get all adapter information and add IP and subnet to a vector pair
	if ((dwRetVal = GetAdaptersInfo(pAdapterInfo, &ulOutBufLen)) == NO_ERROR) 
	{
		pAdapter = pAdapterInfo;

		// Traverse linked-lists of adapters and push vector pairs
		// IP and subnet strings
		while (pAdapter) 
		{
			ipSubnetList.push_back(make_pair(pAdapter->IpAddressList.IpAddress.String, pAdapter->IpAddressList.IpMask.String));
			pAdapter = pAdapter->Next;
		}
	}
	else
		cout << "GetAdaptersInfo failed with error: " << dwRetVal << endl;

	// Free adapterInfo in memory
	if (pAdapterInfo)
		FREE(pAdapterInfo);

	return ipSubnetList;
}

/*
 * Generates the broadcast address using the IP, Subnet and bit arithmetic
 *
 */
vector<string> getBroadcastAddress()
{
	// Create in_addr structs to store IP and subnet
	struct in_addr host, subnet, broadcast;
	char broadcastAddr[INET_ADDRSTRLEN];

	// Create vector pairs and vector to loop list of IP and subnets
	// and generate broadcast IP to store in second vector
	vector<pair<string, string>>::iterator it;
	vector<pair<string, string>> ipSubnetList = getDeviceIP();
	vector<string> broadcastList;
	for (it = ipSubnetList.begin();it != ipSubnetList.end();it++)
	{
		// Remove IP shells on the network
		if (!it->first.compare("0.0.0.0"))continue;

		// Convert IP string into IP format and calculate broadcast IP
		if (InetPton(AF_INET, it->first.c_str(), &host) && InetPton(AF_INET, it->second.c_str(), &subnet))
			broadcast.s_addr = host.s_addr | ~subnet.s_addr;
		else
		{
			cout << "Error: Could not convert IP format to binary" << endl;
			continue;
		}

		// Convert IP format back to string format and add to broadcastList
		if (InetNtop(AF_INET, &broadcast, broadcastAddr, INET_ADDRSTRLEN) != NULL)
			broadcastList.push_back(string(broadcastAddr));
		else
			cout << "Error: Could not convert broadcast to IP" << endl;
	}

	return broadcastList;
}
#endif

#endif
