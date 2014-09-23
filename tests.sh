#!/bin/bash

# Kill the script if we have any errors
set -e

if [ "$(id -u)" != "0" ];
then
    echo "Error; Must run as root."
    exit 1
fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP_DIR=$DIR/testing_directory
TESTS_DIR=$DIR/tests
CMD=../nggroup

# Clean up first - in case the script didn't successfully exit
rm -rf $TMP_DIR

# Then set up our new environment and go into it
mkdir -p $TMP_DIR
cd $TMP_DIR

## <Tests>

for test_script in $TESTS_DIR/*.sh;
do
    env CMD=$CMD $test_script
done

## </Tests>

# Clean up here if we get this far
rm -rf $TMP_DIR

echo "All tests passed"
