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

# CTest must be run from build directory
error=0
(cd ./build && ctest -V)
error=$?

# Exit with error code from tests
exit $error
