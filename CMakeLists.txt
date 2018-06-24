######## Config ########

cmake_minimum_required (VERSION 3.11)

# Declare project
project (SplitSound CXX)

include (cmake/Qt5.cmake)
include (cmake/SplitSound.cmake)

# Version
set (VERSION_MAJOR 0)
set (VERSION_MINOR 0)
set (VERSION_REV 0)
set (VERSION_BUILD 0)
set (VERSION_STAGE dev)
set (VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_REV}.${VERSION_BUILD} ${VERSION_STAGE}")

message (STATUS "")
message (STATUS "Building SplitSound v${VERSION}")
message (STATUS "")

# Set build type if not provided
# Default to DEBUG
if (NOT CMAKE_BUILD_TYPE)
    set (CMAKE_BUILD_TYPE Debug)
endif ()

set (OSX FALSE)
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set (OSX TRUE)
endif ()

set (64BIT FALSE)
if (WIN32 AND CMAKE_GENERATOR_PLATFORM MATCHES "x64")
    set (64BIT TRUE)
endif ()

# Disable coverage flags by default
option (SS_ADD_COVERAGE_FLAGS "Add coverage options to compiler flags" OFF)
if (CMAKE_BUILD_TYPE MATCHES "Debug" AND (CMAKE_CXX_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "AppleClang" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
    set (SS_ADD_COVERAGE_FLAGS ON)
endif ()

# Prevent -Wunused-result from killing the Release build
if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-result")
endif ()

# Set output for binaries
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/lib)
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/lib)
foreach (OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string (TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin)
    set (CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib/lib)
    set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib/lib)
endforeach ()

# Set output for libs compiled with --target install
set (CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/lib)
set (CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR}/lib)

message (STATUS "System Platform: ${CMAKE_SYSTEM_NAME} ${CMAKE_GENERATOR_PLATFORM}\n")

# Initialize lists
set (SRC_FILES)
set (INCLUDE_DIRS)
set (SS_LIBRARIES)

# Link Windows specific libraries
if (WIN32)
    set (SS_LIBRARIES wsock32 ws2_32 iphlpapi)
endif ()




######## Dependencies and Libs ########

message (STATUS "Building required JRTP dependencies...\n")

# Make sure libs build x64 if x64 flag is passed in
if (WIN32 AND 64BIT)
    set (JFLAGS -A x64)
endif ()

# Check if JRTPLIB and JThread libs should be build
if (NOT DEFINED SS_BUILD_JLIBS AND EXISTS "${CMAKE_BINARY_DIR}/lib/lib/cmake/JThread" AND EXISTS "${CMAKE_BINARY_DIR}/lib/lib/JRTPLIB")
    set (SS_BUILD_JLIBS FALSE)
endif ()

# Default to true
if (NOT DEFINED SS_BUILD_JLIBS)
    set (SS_BUILD_JLIBS TRUE)
endif ()

if (SS_BUILD_JLIBS)

    # Manually cmake and install JThread (required for JRTPLIB)
    execute_process (COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/jthread)
    execute_process (COMMAND ${CMAKE_COMMAND} ${CMAKE_SOURCE_DIR}/src/libs/jthread ${JFLAGS} -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/jthread
    )
    execute_process (COMMAND ${CMAKE_COMMAND} --build . --target install
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/jthread
    )

    message (STATUS "Built and installed JThread.")
    message (STATUS "Continuing CMake generation...\n")

    # Add JRTPLIB
    message (STATUS "Building JRTPLIB dependency...\n")

    # Manually cmake and install JRTPLIB
    execute_process (COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/jrtplib)
    execute_process (COMMAND ${CMAKE_COMMAND} ${CMAKE_SOURCE_DIR}/src/libs/jrtplib ${JFLAGS} -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/jrtplib
    )
    execute_process (COMMAND ${CMAKE_COMMAND} --build . --target install
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/jrtplib
    )

    message (STATUS "Built and installed JRTPLIB.")
    message (STATUS "Continuing CMake generation...\n")

else ()

    message (STATUS "SS_BUILD_JLIBS was set to FALSE. JRTPLIB and JThread have not been built.\n")

endif ()

# Find the libraries
# Unix libraries should not include the prefix (i.e. libjrtp is just jrtp)
find_library (JTHREAD_LIB
    NAMES jthread jthread_d
)
find_library (JRTPLIB_LIB
    NAMES jrtplib jrtplib_d jrtp
)

message (STATUS ${JRTPLIB_LIB})
message (STATUS ${JTHREAD_LIB})

# Link built JRTP with current project
include_directories (${CMAKE_BINARY_DIR}/lib/include) # Include generated headers
set (SS_LIBRARIES ${SS_LIBRARIES} ${JTHREAD_LIB} ${JRTPLIB_LIB})




######## Boost ########

set (Boost_USE_MULTITHREADED ON)
set (Boost_USE_STATIC_LIBS ON)
set (Boost_USE_STATIC_RUNTIME OFF)

if (WIN32 AND NOT DEFINED BOOST_ROOT)
    if (DEFINED ENV{BOOST_ROOT})
        set (BOOST_ROOT $ENV{BOOST_ROOT} CACHE STRING "Path to Boost Installation")
    else ()
        message (FATAL_ERROR "BOOST_ROOT environment variable not set. Add the environment variable in Windows Environment Variables or cmake with -DBOOST_ROOT=C:\\path\\to\\boost")
    endif ()
endif ()

message (STATUS "BOOST_ROOT: " ${BOOST_ROOT} "\n")

if (WIN32 AND NOT DEFINED BOOST_LIBRARYDIR)
    if(64BIT)
        set (BOOST_LIBRARYDIR "${BOOST_ROOT}\\lib64-msvc-14.1")
    else ()
        set (BOOST_LIBRARYDIR "${BOOST_ROOT}\\lib32-msvc-14.1")
    endif ()
    message (STATUS "Boost Lib Dir: ${BOOST_LIBRARYDIR}")
endif ()

# Required Boost packages
find_package (Boost REQUIRED COMPONENTS
    system
    filesystem
    thread
    date_time
)

include_directories (${Boost_INCLUDE_DIRS})
set (SS_LIBRARIES ${SS_LIBRARIES} ${Boost_LIBRARIES})




######## Qt ########

# Prime for Qt
set (CMAKE_INCLUDE_CURRENT_DIR ON)
set (CMAKE_AUTOMOC ON)
set (CMAKE_AUTOUIC ON)
set (CMAKE_AUTORCC ON)

if (WIN32 AND NOT DEFINED QT_ROOT)
    if (DEFINED ENV{QT_ROOT})
        set (QT_ROOT $ENV{QT_ROOT} CACHE STRING "Path to Qt Installation")
    else ()
        message (FATAL_ERROR "QT_ROOT environment variable not set. Add the environment variable in Windows Environment Variables or cmake with -DQT_ROOT=C:\\path\\to\\qt\\5.XX.X")
    endif ()
endif ()

message (STATUS "QT_ROOT: " ${QT_ROOT} "\n")

if (WIN32 AND NOT DEFINED Qt5_DIR)
    if(64BIT)
        set (Qt5_DIR "${QT_ROOT}\\msvc2017_64\\lib\\cmake\\Qt5")
    else ()
        set (Qt5_DIR "${QT_ROOT}\\msvc2015\\lib\\cmake\\Qt5")
    endif ()
    message (STATUS "Qt5_DIR: ${Qt5_DIR}")
endif ()

# Required Qt packages
find_package (Qt5 REQUIRED
    Core
    Widgets
    Gui
    Network
    Qml
    Quick
    QuickControls2
    Svg
    Xml
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
    Qt5::Svg
    Qt5::Xml
)




######## Executable ########

# Add coverage flags for GCC
set (CXX_FLAGS_NOCOV "${CMAKE_CXX_FLAGS}")
if (SS_ADD_COVERAGE_FLAGS)
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
endif ()

add_subdirectory (src/gui)
add_subdirectory (src/net)

include_directories(${INCLUDE_DIRS})

# Add executable
if (WIN32)

    add_executable (splitsound ${SRC_FILES})

    # Copy DLLs to binary output directory
    qt5_copy_dll (splitsound Core)
    qt5_copy_dll (splitsound Widgets)
    qt5_copy_dll (splitsound Gui)
    qt5_copy_dll (splitsound Network)
    qt5_copy_dll (splitsound Qml)
    qt5_copy_dll (splitsound Quick)
    qt5_copy_dll (splitsound QuickControls2)
    qt5_copy_dll (splitsound Svg)
    qt5_copy_dll (splitsound Xml)

    qt5_post_build_windeployqt(splitsound ${CMAKE_SOURCE_DIR}/src/gui/res)

elseif (OSX)

    add_executable(splitsound ${SRC_FILES})
    # TODO later: qt5_post_build_macdeployqt(splitsound ${CMAKE_SOURCE_DIR}/src/gui/res)

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

    include (cmake/Testing.cmake)

endif ()
