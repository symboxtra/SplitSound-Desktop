add_executable(BroadcastAddress BroadcastAddress.cpp)

if(WIN32)
	target_link_libraries(BroadcastAddress wsock32 ws2_32 iphlpapi)

endif()
