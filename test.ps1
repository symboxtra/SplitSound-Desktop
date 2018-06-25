#########################################################
#                                                       #
#   Build and Test QT for Windows using MSVC compiler   #
#                                                       #
#########################################################

cd .\build\

# Generate executable using CMake
""
Write-Host "===== Building... =====" -Foreground Yellow
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
OpenCppCoverage --export_type=cobertura:cobertura.xml (get-item .\bin\test\*.exe)>$null 2>$null
#if($LastExitCode -ne 0) {$host.SetShouldExit($LastExitCode)} # Exit with test error code

Write-Host "Coverage Report generated." -Foreground Green
""

cd ..
