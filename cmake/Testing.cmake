# Prevent overriding of compiler/linker options
if (WIN32)
    set (gtest_force_shared_crt ON CACHE BOOL "" FORCE)
endif ()

# Enable testing and build googletest submodule
enable_testing ()
add_subdirectory (src/libs/googletest)

# Change flags only for gcc compiler
if (SS_ADD_COVERAGE_FLAGS)
    # Enable GCOV flags
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
endif ()

# Include directories needed for testing
include_directories (
    ${CMAKE_SOURCE_DIR}/src/libs/googletest/googletest/include/gtest
    ${CMAKE_SOURCE_DIR}/src/libs/googletest/googlemock/include/gmock
)

# Collect all test source files
file (GLOB TEST_SRC_FILES ${CMAKE_SOURCE_DIR}/src/test/*/*.cpp)

# Remove all gui tests from 
file (GLOB GUI_TESTS ${CMAKE_SOURCE_DIR}/src/test/gui/*.cpp)
if (${GUI_TESTS})
    list (REMOVE ITEM TEST_SRC_FILES ${GUI_TESTS})
endif ()

# Move test executables to bin/test
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/test)
foreach (OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string (TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin/test)
endforeach ()

# Create executables and CTest for each file
foreach (_test_file ${TEST_SRC_FILES})
    get_filename_component (_test_name ${_test_file} NAME_WE)
    add_executable (${_test_name} ${_test_file})
	target_link_libraries (${_test_name} ${SS_LIBRARIES} gtest gtest_main ${CMAKE_THREAD_LIBS_INIT})

	message (STATUS "Linked Libraries: ${SS_LIBRARIES}\n")

	add_test (NAME ${_test_name} COMMAND ${_test_name} "--gtest_color=yes") # Point ctest to bin/test
    set_tests_properties (${_test_name} PROPERTIES TIMEOUT 5)
endforeach()
