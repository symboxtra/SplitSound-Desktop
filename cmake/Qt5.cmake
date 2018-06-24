# Macro to call windeployqt after building
macro (qt5_post_build_windeployqt APP QMLDIR)

    # Get bin directory of Qt from Qt5Core.dll
    find_package (Qt5 REQUIRED Core)
    get_target_property (Qt5_CoreLocation Qt5::Core LOCATION)
    get_filename_component (QTBIN ${Qt5_CoreLocation} DIRECTORY)
    message (STATUS "\nQt bin: " ${QTBIN} "\n")
    
    # Just copy manually to avoid the trouble
    add_custom_command (TARGET ${APP} POST_BUILD
       COMMAND ${CMAKE_COMMAND} -E copy_if_different $<$<CONFIG:Debug>:"${QTBIN}/Qt5QuickTemplates2d.dll"> $<$<NOT:$<CONFIG:Debug>>:"${QTBIN}/Qt5QuickTemplates2.dll"> $<TARGET_FILE_DIR:${APP}>)
    
    add_custom_command (TARGET ${APP} POST_BUILD
            COMMAND "${QTBIN}/windeployqt.exe" -qmldir ${QMLDIR} $<TARGET_FILE:${APP}> WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
     
    message (STATUS "Added post-build call to windeployqt")

endmacro ()

# Macro to call macdeployqt after building
macro (qt5_post_build_macdeployqt APP QMLDIR)

    # Get bin directory of Qt from Qt5Core.dll
    find_package (Qt5 REQUIRED Core)
    get_target_property (Qt5_CoreLocation Qt5::Core LOCATION)
    
    # Strip to bin directory
    get_filename_component (QTBIN ${Qt5_CoreLocation} DIRECTORY) 
    get_filename_component (QTBIN ${QTBIN} DIRECTORY)
    get_filename_component (QTBIN ${QTBIN} DIRECTORY)
    set (QTBIN "${QTBIN}/bin")
    
    message (STATUS "\nQt bin: " ${QTBIN} "\n")
    
    add_custom_command (TARGET ${APP} POST_BUILD
            COMMAND ${QTBIN}/macdeployqt -qmldir ${QMLDIR} $<TARGET_FILE:${APP}> WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
     
    MESSAGE(STATUS "Added post-build call to macdeployqt")

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