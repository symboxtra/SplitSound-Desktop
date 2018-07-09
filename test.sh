#!/bin/bash

#########################################################
#                                                       #
#      Run test suite and generate coverage reports     #
#                                                       #
#########################################################

RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;96m'
NC='\033[0m' # No color
echo

echo -e "${YELLOW}=== Building... ===${NC}"
echo

cmake --build ./build

echo
echo -e "${YELLOW}=== Testing... ===${NC}"
echo

# Generate base coverage
echo "Generating base coverage report..."
lcov -c -i -d build -o build/coverage.base
echo

# CTest must be run from build directory
error=0
(cd ./build && ctest -V)
error=$?

echo
echo -e "${YELLOW}=== Collecting coverage data... ===${NC}"
echo

lcov -c -d build -o build/coverage.actual
lcov -a build/coverage.base -a build/coverage.actual -o build/coverage.info

# Remove the separate reports
rm build/coverage.base build/coverage.actual

echo ""
echo "Cleaning coverage report..."

# Download script to strip mismarked function lines
# Ref: https://github.com/linux-test-project/lcov/issues/30#issuecomment-353799085
if [ ! -f ./remove-function-lines.py ]; then
    curl https://raw.githubusercontent.com/symboxtra/lcov-llvm-function-mishit-filter/master/remove-function-lines.py > remove-function-lines.py && chmod +x remove-function-lines.py
fi

# Execute script if report was generated
if [ -f build/coverage.info ]; then
    python remove-function-lines.py build/coverage.info build/coverage.info
    echo "Coverage report cleaned."
fi

echo ""
if [ $error -eq 0 ]; then
    echo -e "${YELLOW}BUILD SUCCESSFUL${NC}"
else
    echo -e "${RED}BUILD FAILED${NC}"
fi
echo ""

# Exit with error code from tests
exit $error
