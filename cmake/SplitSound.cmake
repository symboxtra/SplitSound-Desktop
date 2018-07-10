# Manually generate and build a CMake project at generation time
function (generate_and_install_lib _name _generation_flags)
    set (PROCESS_RESULT 0)

    message (STATUS "Building and installing library ${_name} to ${CMAKE_INSTALL_PREFIX}...\n")
    string (TOLOWER "${_name}" _name_lower)
    
    # Manually generate and install
    execute_process (COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/${_name})
    execute_process (COMMAND ${CMAKE_COMMAND} ${CMAKE_SOURCE_DIR}/src/libs/${_name_lower} ${_generation_flags} -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/${_name}
        RESULT_VARIABLE PROCESS_RESULT
    )

    # Make sure generation did not fail
    if (NOT PROCESS_RESULT EQUAL 0)
        message (FATAL_ERROR "\nCMake generation of ${_name} failed with return code ${PROCESS_RESULT}\n")
    endif ()

    execute_process (COMMAND ${CMAKE_COMMAND} --build . --target install
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/${_name}
        RESULT_VARIABLE PROCESS_RESULT
    )

    # Make sure build did not fail
    if (NOT PROCESS_RESULT EQUAL 0)
        message (FATAL_ERROR "\nCMake build of ${_name} failed with return code ${PROCESS_RESULT}\n")
    endif ()

    message (STATUS "")
    message (STATUS "Built and installed ${_name}.")
    message (STATUS "Continuing CMake generation...\n")

endfunction ()

# Macro for collecting source files
macro (add_sources)
    file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_src ${ARGN})
        if (_relPath)
            list (APPEND SRC_FILES "${_relPath}/${_src}")
        else ()
            list (APPEND SRC_FILES "${_src}")
        endif ()
    endforeach()
    if (_relPath)
        # propagate SRCS to parent directory
        set (SRC_FILES ${SRC_FILES} PARENT_SCOPE)
    endif ()
endmacro ()

# Macro for collectinrheader files
macro (add_include_dir)
    file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_dir ${ARGN})
        if (_relPath)
            list (APPEND INCLUDE_DIRS "${_relPath}/${_dir}")
        else ()
            list (APPEND INCLUDE_DIRS "${_dir}")
        endif ()
    endforeach()
    if (_relPath)
        # propagate DIRS to parent directory
        set (INCLUDE_DIRS ${INCLUDE_DIRS} PARENT_SCOPE)
    endif ()
endmacro ()