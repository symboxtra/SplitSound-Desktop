function (create_test _test_file _src_files _timeout)

    get_filename_component (_test_name ${_test_file} NAME_WE)
    add_executable (${_test_name} ${_test_file} ${_src_files})
    target_link_libraries (${_test_name} ${SS_LIBRARIES} gtest gtest_main ${CMAKE_THREAD_LIBS_INIT})

    add_test (
        NAME ${_test_name}
        COMMAND ${_test_name} "--gtest_color=yes"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/bin" #
    )

    if (_timeout GREATER 0)
        set_tests_properties (${_test_name} PROPERTIES TIMEOUT ${_timeout})
    endif ()

endfunction ()

# Make gui tests opt-out
# These tests can't be run on headless platforms
if (NOT DEFINED SS_INCLUDE_GUI_TESTS)
    set (SS_INCLUDE_GUI_TESTS true)
endif ()

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

# Let the linker know it should check bin
link_directories (
    ${CMAKE_BINARY_DIR}/bin
)

# Collect all test source files
file (GLOB TEST_SRC_FILES ${CMAKE_SOURCE_DIR}/src/test/*/*.cpp)

set (T_TEST_DIR "${CMAKE_SOURCE_DIR}/src/test")
set (T_GUI_DIR "${CMAKE_SOURCE_DIR}/src/gui")

# Add the GUI tests to the bin directory instead of bin/test
# GUI tests need the Qt dlls in bin
if (SS_INCLUDE_GUI_TESTS)
    create_test("${T_TEST_DIR}/gui/TestGui.cpp" "${T_GUI_DIR}/src/QSplitSoundApplication.cpp;${T_GUI_DIR}/src/MainWindow.cpp;${T_GUI_DIR}/src/QQmlBridge.cpp;${T_GUI_DIR}/res/SplitSound.qrc" -1)
else ()
    message (STATUS "Ignoring GUI tests. Set SS_INCLUDE_GUI_TESTS=true to include.")
endif ()

# Output test executables to bin/test
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/test)
foreach (OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string (TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin/test)
endforeach ()

# Add more tests here using create_test()
create_test("${T_TEST_DIR}/basic/TestQuickMaths.cpp" "" -1)