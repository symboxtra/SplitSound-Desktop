# Collect all source files
file(GLOB SRC_FILES ${PROJECT_SOURCE_DIR}/src/net/*.cpp)

foreach(_test_file ${SRC_FILES})
	get_filename_component(_test_name ${_test_file} NAME_WE)
	add_executable(${_test_name} ${_test_file})
	if(WIN32)
		target_link_libraries(${_test_name} wsock32 ws2_32 iphlpapi)
	endif()
endforeach()
