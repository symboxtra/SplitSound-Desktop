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

# Set output for binaries
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib) # TODO: ?
foreach (OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string (TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin)
    set (CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib)
    set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib) # TODO: ?
endforeach (OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES)

# GUI/non-GUI build
option (COMMAND_LINE_BUILD "Compile for command line use only (no GUI)" OFF)
if (NOT COMMAND_LINE_BUILD)
	
	# Prime for Qt
	set (CMAKE_INCLUDE_CURRENT_DIR ON)
	set (CMAKE_AUTOMOC ON)
	set (CMAKE_AUTOUIC ON)

	# Find Qt (check CMake flags first, then environment variable)
	if (NOT DEFINED Qt5_DIR)
		if (NOT DEFINED ENV{QTDIR})
			MESSAGE(FATAL_ERROR "QTDIR environment variable not set. Be sure to set the QTDIR cmake cache variable to the Qt root install location.")
		endif ()
	endif ()

	# Cache and print Qt location
	set (Qt5_DIR $ENV{QTDIR} CACHE STRING "Qt install path")
	MESSAGE(STATUS "Qt5_DIR: " ${Qt5_DIR})

	# Required Qt packages
	find_package(Qt5 REQUIRED
		Core 
		Widgets
		Gui
	)

	# Macro for lower level CMakeLists to copy DLLs
	macro (qt5_copy_dll APP DLL)
		# find the release *.dll file
		get_target_property(Qt5_${DLL}Location Qt5::${DLL} LOCATION)
		# find the debug *d.dll file
		get_target_property(Qt5_${DLL}LocationDebug Qt5::${DLL} IMPORTED_LOCATION_DEBUG)

		add_custom_command(TARGET ${APP} POST_BUILD
		   COMMAND ${CMAKE_COMMAND} -E copy_if_different $<$<CONFIG:Debug>:${Qt5_${DLL}LocationDebug}> $<$<NOT:$<CONFIG:Debug>>:${Qt5_${DLL}Location}> $<TARGET_FILE_DIR:${APP}>)
	endmacro ()
	
	add_subdirectory(src/helloworld)
	
endif ()

# Build settings for DEBUG builds only
if (CMAKE_BUILD_TYPE MATCHES "Debug")
    enable_testing()
    add_subdirectory(src/libs/googletest)
endif ()
