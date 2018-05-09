#ifndef BROADCASTADDRESS
#define BROADCASTADDRESS

#include <vector>
#include <iostream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>

using namespace std;

#if defined(__linux__) ||  defined(__APPLE__)

// Unix (GNU/Clang++) includes
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <ifaddrs.h>

/* Gets the IP address of all the network connections of local machine */
vector<pair<string, string> > getIPSubnetList()
{
	// Create variables and structs for IP storage and system calls
	vector<pair<string, string> > ipSubnetList;
	struct ifaddrs *ifap, *ifa;
	struct sockaddr_in *sa;
	string addr;

	// Get network adapter and loop through all the containers
	// to recieve network information
	getifaddrs(&ifap);
	for(ifa = ifap;ifa;ifa = ifa->ifa_next)
	{
		if(ifa->ifa_addr->sa_family==AF_INET)
		{
			sa = (struct sockaddr_in*) ifa->ifa_netmask;
			addr = string(inet_ntoa(sa->sin_addr));
			sa = (struct sockaddr_in*)ifa->ifa_addr;
			 
			// Add subnet and IP and generate a list
			ipSubnetList.push_back(make_pair(string(inet_ntoa(sa->sin_addr)), addr));
		}
	}

	freeifaddrs(ifap);
	return ipSubnetList;
}

/* Generates the broadcast address using the IP, Subnet and bit arithmetic */
vector<string> getBroadcastAddress()
{
	// Crate inet_addr struct to store IP and subnet
	struct in_addr host, subnet, broadcast;
	char broadcastAddr[INET_ADDRSTRLEN];

	// Create vector pairs and vector to loop list of IP and subnets
	// and generate broadcast IP to store in second vector
	vector<string> broadcastList;
	for(auto const& ipPair : getIPSubnetList())
	{

		// Remove IP shells on the network
		if (!ipPair.first.compare("0.0.0.0"))continue;

		// Remove localhost from list
		if(!ipPair.first.compare("127.0.0.1"))continue;

		// Convert IP string into IP format and calculate broadcast IP
		if(inet_pton(AF_INET, ipPair.first.c_str(), &host) && inet_pton(AF_INET, ipPair.second.c_str(), &subnet))
			broadcast.s_addr = host.s_addr | ~subnet.s_addr;
		else
		{
			cout << "Error: Could not convert IP to binary" << endl;
			exit(1);
		}

		// Convert IP format back to string format and add to broadcastList
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

// Windows (MSVC) includes
#include <winsock2.h>
#include <Ws2tcpip.h>
#include <Iphlpapi.h>

#define MALLOC(x) HeapAlloc(GetProcessHeap(), 0, (x))
#define FREE(x) HeapFree(GetProcessHeap(), 0, (x))

/* Gets the IP address of all the network connections of local machine */
vector<pair<string, string>> getIPSubnetList()
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

/* Generates the broadcast address using the IP, Subnet and bit arithmetic */
vector<string> getBroadcastAddress()
{
	// Create in_addr structs to store IP and subnet
	struct in_addr host, subnet, broadcast;
	char broadcastAddr[INET_ADDRSTRLEN];

	// Create vector pairs and vector to loop list of IP and subnets
	// and generate broadcast IP to store in second vector
	vector<string> broadcastList;
	for(auto const& ipPair : getIPSubnetList())
	{
		// Remove IP shells on the network
		if (!ipPair.first.compare("0.0.0.0"))continue;
		
		// Remove localhost from list
		if(!ipPair.first.compare("127.0.0.1"))continue;

		// Convert IP string into IP format and calculate broadcast IP
		if (InetPton(AF_INET, ipPair.first.c_str(), &host) && InetPton(AF_INET, ipPair.second.c_str(), &subnet))
			broadcast.s_addr = host.s_addr | ~subnet.s_addr;
		else
		{
			cout << "Error: Could not convert IP format to binary" << endl;
			exit(1);
		}

		// Convert IP format back to string format and add to broadcastList
		if (InetNtop(AF_INET, &broadcast, broadcastAddr, INET_ADDRSTRLEN) != NULL)
			broadcastList.push_back(string(broadcastAddr));
		else
		{
			cout << "Error: Could not convert broadcast to IP" << endl;
			exit(1);
		}
	}

	return broadcastList;
}
#endif

#endif
