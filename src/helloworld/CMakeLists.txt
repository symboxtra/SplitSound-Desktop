if (WIN32)

	add_executable(hello-world WIN32 src/test.cpp)

	# Copy DLLs to binary output directory
	qt5_copy_dll(hello-world Core)
	qt5_copy_dll(hello-world Widgets)
	qt5_copy_dll(hello-world Gui)
	
else ()

	add_executable(hello-world src/Test.cpp)
	
endif ()

# Link Qt 
target_link_libraries(hello-world Qt5::Core Qt5::Widgets Qt5::Gui)


