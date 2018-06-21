######## Config ########

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

if (WIN32)
	set (SS_LIBRARIES wsock32 ws2_32 "iphlpapi;")
else()
	set (SS_LIBRARIES ${CMAKE_THREAD_LIBS_INIT})
endif()

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


######## Dependencies and Libs ########

message(STATUS "\nBuilding required dependency JThread...\n")

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
MESSAGE(STATUS "\nBuilding JRTPLIB dependency...\n")

# Manually cmake and install JRTPLIB
execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/jrtplib)
execute_process(COMMAND ${CMAKE_COMMAND} ${CMAKE_SOURCE_DIR}/src/libs/jrtplib -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/lib
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/jrtplib
)
execute_process(COMMAND ${CMAKE_COMMAND} --build . --target install
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/jrtplib
)
MESSAGE(STATUS "\nBuilt and installed JRTPLIB\n")

include_directories("${CMAKE_BINARY_DIR}/lib/include") # Include generated headers
#set (SS_LIBRARIES ${SS_LIBRARIES} ${CMAKE_BINARY_DIR}/lib/lib/jthread_d.lib ${CMAKE_BINARY_DIR}/lib/lib/jrtplib_d.lib)


######## Boost ########

set (Boost_USE_MULTITHREADED ON)
set (Boost_USE_STATIC_LIBS ON)
set (Boost_USE_STATIC_RUNTIME OFF)
set (Boost_ALL_DYN_LINK OFF)
set (Boost_USE_DEBUG_LIBS ON)
if (NOT DEFINED BOOST_LIBRARYDIR)
	set (BOOST_LIBRARYDIR ${BOOST_ROOT}/lib64-msvc14.1)
endif()
MESSAGE (STATUS "Boost Lib Dir: ${BOOST_LIBRARYDIR}")

if (NOT DEFINED BOOST_ROOT)
	if(DEFINED ENV{BOOST})
		set (BOOST_ROOT $ENV{BOOST} CACHE STRING "Path to Boost installation")
	endif()
endif()
MESSAGE(STATUS "BOOST_ROOT: " ${BOOST_ROOT} "\n")

# Required Boost packages
find_package(Boost REQUIRED
	system
	filesystem
	thread
	date_time
)

include_directories(${Boost_INCLUDE_DIRS})
set(SS_LIBRARIES ${SS_LIBRARIES} ${Boost_LIBRARIES})


######## Qt ########

# Prime for Qt
set (CMAKE_INCLUDE_CURRENT_DIR ON)
set (CMAKE_AUTOMOC ON)
set (CMAKE_AUTOUIC ON)
set (CMAKE_AUTORCC ON)

# Cache and print Qt location
if (NOT DEFINED Qt5_DIR)
    if (DEFINED ENV{QTDIR})
        set (Qt5_DIR $ENV{QTDIR} CACHE STRING "Path to Qt installation")
    endif ()
endif ()
MESSAGE(STATUS "\nQt5_DIR: " ${Qt5_DIR} "\n")

# Make sure Qt was found on Windows
if (WIN32)

    if (NOT DEFINED Qt5_DIR)
        MESSAGE(FATAL_ERROR "QTDIR environment variable not set. Add the environment variable in Windows Environment Variables or cmake with -DQt5_DIR=C:\\path\\to\\Qt.")
    endif ()

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
    Network
    Qml
    Quick
    QuickControls2
)

set (SS_LIBRARIES 
		${SS_LIBRARIES}
		Qt5::Core
		Qt5::Widgets
		Qt5::Gui
		Qt5::Network
		Qt5::Qml
		Qt5::Quick
		Qt5::QuickControls2
)


######## Executable ########

# Add coverage flags for GCC
set (CXX_FLAGS_NOCOV "${CMAKE_CXX_FLAGS}")
if (SS_ADD_COVERAGE_FLAGS)
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
endif()

# Define macro for collecting source files
macro (add_sources)
    file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_src ${ARGN})
        if (_relPath)
            list (APPEND SRC_FILES "${_relPath}/${_src}")
        else()
            list (APPEND SRC_FILES "${_src}")
        endif()
    endforeach()
    if (_relPath)
        # propagate SRCS to parent directory
        set (SRC_FILES ${SRC_FILES} PARENT_SCOPE)
    endif()
endmacro()

add_subdirectory(src/gui)
add_subdirectory(src/net)

# Add executable
if (WIN32)

    add_executable(splitsound ${SRC_FILES})

    # Copy DLLs to binary output directory
    qt5_copy_dll(splitsound Core)
    qt5_copy_dll(splitsound Widgets)
    qt5_copy_dll(splitsound Gui)
    qt5_copy_dll(splitsound Network)
    qt5_copy_dll(splitsound Qml)
    qt5_copy_dll(splitsound Quick)
    qt5_copy_dll(splitsound QuickControls2)


else ()

    add_executable(splitsound ${SRC_FILES})

endif ()

# Link Qt
target_link_libraries(splitsound ${SS_LIBRARIES})

# Turn off coverage flags
set (CMAKE_CXX_FLAGS "${CXX_FLAGS_NOCOV}")




####### Testing #######

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
        ${PROJECT_SOURCE_DIR}/src/gui/src
		${PROJECT_SOURCE_DIR}/src/net
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
		target_link_libraries(${_test_name} ${SS_LIBRARIES} gtest gtest_main ${CMAKE_THREAD_LIBS_INIT})
		MESSAGE (STATUS "Libs: ${SS_LIBRARIES}")
		add_test(NAME ${_test_name} COMMAND ${_test_name} "--gtest_color=yes") # Point ctest to bin/test
        set_tests_properties(${_test_name} PROPERTIES TIMEOUT 5)
    endforeach()

endif ()
