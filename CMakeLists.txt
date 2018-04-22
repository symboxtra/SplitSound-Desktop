cmake_minimum_required (VERSION 3.5)

# Declare project
project (SplitSound CXX)

# Version
set (VERSION_MAJOR 0)
set (VERSION_MINOR 0)
set (VERSION_REV 0)
set (VERSION_STAGE dev)
set (VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_REV} ${VERSION_STAGE}")

# Set build type if not provided
# Default to DEBUG
if (NOT CMAKE_BUILD_TYPE) 
    set (CMAKE_BUILD_TYPE Debug)
endif ()

# Ensure libraries are installed correctly on all platforms
# include(GNUInstallDirs)

# Set C++ compiler flags for GCOV report
set (CMAKE_CXX_FLAGS "-fprofile-arcs -ftest-coverage")

# Set output for binaries
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib) # TODO: ?
foreach (OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string (TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin)
    set (CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib)
    set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib) # TODO: ?
endforeach ()

# GUI/non-GUI build
option (COMMAND_LINE_BUILD "Compile for command line use only (no GUI)" OFF)
if (NOT COMMAND_LINE_BUILD)
	
	# Prime for Qt
	set (CMAKE_INCLUDE_CURRENT_DIR ON)
	set (CMAKE_AUTOMOC ON)
	set (CMAKE_AUTOUIC ON)

	if (WIN32)
		# Find Qt on Windows (check CMake flags first, then environment variable)
		if (NOT DEFINED Qt5_DIR)
			if (NOT DEFINED ENV{QTDIR})
				MESSAGE(FATAL_ERROR "QTDIR environment variable not set. Add the environment variable in Windows Environment Variables or cmake with -DQt5_DIR=C:\\path\\to\\Qt.")
			endif ()
		endif ()

		# Cache and print Qt location
		set (Qt5_DIR $ENV{QTDIR} CACHE STRING "Qt install path")
		MESSAGE(STATUS "Qt5_DIR: " $	{Qt5_DIR})
		
		# Macro for lower level CMakeLists to copy DLLs
		macro (qt5_copy_dll APP DLL)
			# find the release *.dll file
			get_target_property(Qt5_${DLL}Location Qt5::${DLL} LOCATION)
			# find the debug *d.dll file
			get_target_property(Qt5_${DLL}LocationDebug Qt5::${DLL} IMPORTED_LOCATION_DEBUG)

			add_custom_command(TARGET ${APP} POST_BUILD
			   COMMAND ${CMAKE_COMMAND} -E copy_if_different $<$<CONFIG:Debug>:${Qt5_${DLL}LocationDebug}> $<$<NOT:$<CONFIG:Debug>>:${Qt5_${DLL}Location}> $<TARGET_FILE_DIR:${APP}>)
		endmacro ()
	endif ()

	# Required Qt packages
	find_package(Qt5 REQUIRED		
		Core 
		Widgets
		Gui
	)
	
	add_subdirectory(src/helloworld)
	
endif ()

# Build settings for DEBUG builds only
if (CMAKE_BUILD_TYPE MATCHES "Debug")
	# Prevent overriding compiler/linker options
	if (WIN32)
		set (gtest_force_shared_crt ON CACHE BOOL "" FORCE)
	endif ()	

	# Temporarily disable GCOV flags
	set (CMAKE_CXX_FLAGS "")

	# Enable testing and build googletest submodule
	enable_testing()
    add_subdirectory(src/libs/googletest)

	# Re-enable GCOV flags
	set (CMAKE_CXX_FLAGS "-fprofile-arcs -ftest-coverage")

	# Include directories needed for testing
	include_directories(
		${PROJECT_SOURCE_DIR}/src/libs/googletest/googletest/include/gtest
		${PROJECT_SOURCE_DIR}/src/libs/googletest/googlemock/include/gmock
		${PROJECT_SOURCE_DIR}/src/helloworld/src
	)
	
	# Collect all test source files
	file(GLOB TEST_SRC_FILES ${PROJECT_SOURCE_DIR}/src/test/*/*.cpp)
	
	# Move test executables to bin/test
	set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/test)
	foreach (OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
		string (TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
		set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin/test)
	endforeach ()


	# Create executables and CTest for each file
	foreach(_test_file ${TEST_SRC_FILES})
		get_filename_component(_test_name ${_test_file} NAME_WE)
		add_executable(${_test_name} ${_test_file})
		target_link_libraries(${_test_name} gtest gtest_main ${CMAKE_THREAD_LIBS_INIT})
		add_test(NAME ${_test_name} COMMAND ${_test_name} "--gtest_color=yes") # Point ctest to bin/test	
		set_tests_properties(${_test_name} PROPERTIES TIMEOUT 5)

		# Compile test files before running gcov
#		add_dependencies(gcov ${_test_name})
	endforeach()

	# Clean gcov to prevent override
	#add_custom_target(scrub
	#	COMMAND rm -f ${OBJECT_DIR}
	#)


endif ()
