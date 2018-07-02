# Macro to call windeployqt after building
macro (qt5_post_build_windeployqt APP QMLDIR)

    # Get bin directory of Qt from Qt5Core.dll
    find_package (Qt5 REQUIRED Core)
    get_target_property (Qt5_CoreLocation Qt5::Core LOCATION)
    get_filename_component (QTBIN ${Qt5_CoreLocation} DIRECTORY)

    find_program(WINDEPLOYQT_EXECUTABLE
        NAMES
            "windepoyqt"
        PATHS
            "${QTBIN}"

        NO_SYSTEM_ENVIRONMENT_PATH
    )

    message (STATUS "WINDEPLOYQT: ${WINDEPLOYQT_EXECUTABLE}")

    if (${WINDEPLOYQT_EXECUTABLE} STREQUAL "WINDEPLOYQT_EXECUTABLE-NOTFOUND")
        message (FATAL_ERROR "\nCould not find windeployqt.\n")
    endif ()

    add_custom_command (TARGET ${APP} POST_BUILD
            COMMAND ${WINDEPLOYQT_EXECUTABLE} -qmldir ${QMLDIR} $<TARGET_FILE:${APP}> WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})

    message (STATUS "Added post-build call to windeployqt.")

endmacro ()

# Macro to call macdeployqt after building
macro (qt5_post_build_macdeployqt APP QMLDIR)

    find_program(MACDEPLOYQT_EXECUTABLE
        NAMES
            "macdeployqt"
    )

    if (${MACDEPLOYQT_EXECUTABLE} STREQUAL "MACDEPLOYQT_EXECUTABLE-NOTFOUND")
        message (FATAL_ERROR "\nCould not find macdeployqt. Please make sure the Qt bin folder is on PATH.\n")
    endif ()

    add_custom_command (TARGET ${APP} POST_BUILD
            COMMAND ${MACDEPLOYQT_EXECUTABLE} -qmldir ${QMLDIR} $<TARGET_FILE:${APP}> WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})

    message (STATUS "Added post-build call to macdeployqt.")

endmacro ()

# Macro to copy Qt dlls on Windows
macro (qt5_copy_dll APP DLL)
    # find the release *.dll file
    get_target_property(Qt5_${DLL}Location Qt5::${DLL} LOCATION)
    # find the debug *d.dll file
    get_target_property(Qt5_${DLL}LocationDebug Qt5::${DLL} IMPORTED_LOCATION_DEBUG)

    add_custom_command(TARGET ${APP} POST_BUILD
       COMMAND ${CMAKE_COMMAND} -E copy_if_different $<$<CONFIG:Debug>:${Qt5_${DLL}LocationDebug}> $<$<NOT:$<CONFIG:Debug>>:${Qt5_${DLL}Location}> $<TARGET_FILE_DIR:${APP}>)
endmacro ()
