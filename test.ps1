#########################################################
#                                                       #
#   Build and Test QT for Windows using MSVC compiler   #
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
""
Write-Host "===== Building Executable... =====" -Foreground Yellow
""
cmake --build .
if ($LastExitCode -ne 0) {$host.SetShouldExit($LastExitCode)}

# Tests using googletest suite
""
Write-Host "===== Testing... =====" -Foreground Yellow
""
ctest -C Debug -V
if ($LastExitCode -ne 0) {$host.SetShouldExit($LastExitCode)} # Exit with test error code

# Generate Coverage Report 
""
Write-Host "===== Generating Coverage Report... =====" -Foreground Yellow
""
OpenCppCoverage --export_type=cobertura:cobertura.xml (get-item .\bin\test\*.exe)>$null
if($LastExitCode -ne 0) {$host.SetShouldExit($LastExitCode)} # Exit with test error code
