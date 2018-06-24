
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