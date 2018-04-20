#########################################################
#                                                       #
#		Build QT for Windows using MSVC compiler		#
#                                                       #
#########################################################

""
# Create build folders
rm -r build > $null 2>&1
mkdir build > $null
cd build > $null

# Generate and build CMake

Write-Host "===== Building CMake... =====" -Foreground Yellow
""

# Build CMake for 64-bit arch 
cmake .. -A x64
if ($LastExitCode -ne 0) {$host.SetShouldExit($LastExitCode)}

# Generate executable using CMake
Write-Host "===== Building CMake... =====" -Foreground Yellow
""
cmake --build .
if ($LastExitCode -ne 0) {$host.SetShouldExit($LastExitCode)}
