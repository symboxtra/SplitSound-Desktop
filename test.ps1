#########################################################
#                                                       #
#		Build QT for Windows using MSVC compiler		#
#                                                       #
#########################################################

""
# Create build folders
mkdir build
cd build
cmake .. -A x64
cmake --build .
