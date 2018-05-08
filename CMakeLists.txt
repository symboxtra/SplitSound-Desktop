cmake_minimum_required (VERSION 3.5)
set (CMAKE_CXX_STANDARD 11)

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

# Disable coverage flags by default
option(SS_ADD_COVERAGE_FLAGS "Add coverage options to compiler flags" OFF)
if (CMAKE_BUILD_TYPE MATCHES "Debug" AND (CMAKE_CXX_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "AppleClang" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
    set(SS_ADD_COVERAGE_FLAGS ON)
endif ()

# Set output for binaries
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/lib)
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/lib) # TODO: ?
foreach (OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string (TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin)
    set (CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib/lib)
    set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib/lib) # TODO: ?
endforeach ()

message(STATUS "\nBuilding needed dependency JThread...\n")

# Manually cmake and install JThread (required for JRTPLIB)
execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/jthread)
execute_process(COMMAND ${CMAKE_COMMAND} ${CMAKE_SOURCE_DIR}/src/libs/jthread -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/lib
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/jthread
)
execute_process(COMMAND ${CMAKE_COMMAND} --build . --target install
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/jthread
)

message(STATUS "\nBuilt and installed JThread.\nContinuing CMake generation...\n")

# Prevent -Wunused-result from killing the Release build
if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-result")
endif()

# Add JRTPLIB
set (CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/lib)
add_subdirectory(src/libs/jrtplib)
include_directories(${CMAKE_BINARY_DIR}/src/libs/jrtplib/src) # Include generated headers

# Prime for Qt
set (CMAKE_INCLUDE_CURRENT_DIR ON)
set (CMAKE_AUTOMOC ON)
set (CMAKE_AUTOUIC ON)

# Find Qt on Windows (check CMake flags first, then environment variable)
if (WIN32)

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

# Change flags only for gcc compiler
set (CXX_FLAGS_NOCOV "${CMAKE_CXX_FLAGS}")
if (SS_ADD_COVERAGE_FLAGS)
	set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
endif()

add_subdirectory(src/helloworld)
add_subdirectory(src/net)

# Turn off coverage flags
set (CMAKE_CXX_FLAGS "${CXX_FLAGS_NOCOV}")

# Build settings for DEBUG builds only
if (CMAKE_BUILD_TYPE MATCHES "Debug")
	# Prevent overriding compiler/linker options
	if (WIN32)
		set (gtest_force_shared_crt ON CACHE BOOL "" FORCE)
	endif ()

	# Enable testing and build googletest submodule
	enable_testing()
    add_subdirectory(src/libs/googletest)

	# Change flags only for gcc compiler
	if (SS_ADD_COVERAGE_FLAGS)
		# Enable GCOV flags
		set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
	endif()

	# Include directories needed for testing
	include_directories(
		${PROJECT_SOURCE_DIR}/src/libs/googletest/googletest/include/gtest
		${PROJECT_SOURCE_DIR}/src/libs/googletest/googlemock/include/gmock
		${PROJECT_SOURCE_DIR}/src/helloworld/src
		${PROJECT_SOURCE_DIR}/src/net/
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
		if(WIN32)
			target_link_libraries(${_test_name} wsock32 ws2_32 iphlpapi gtest gtest_main ${CMAKE_THREAD_LIBS_INIT})
		else()
			target_link_libraries(${_test_name} gtest gtest_main ${CMAKE_THREAD_LIBS_INIT})
		endif()
		add_test(NAME ${_test_name} COMMAND ${_test_name} "--gtest_color=yes") # Point ctest to bin/test	
		set_tests_properties(${_test_name} PROPERTIES TIMEOUT 5)
	endforeach()

endif ()
