#!/bin/bash

# Kill the script if we have any errors
set -e

error_alert () {
    >&2 echo "Error: test failed in $@"
}

trap 'error_alert $test_script' ERR

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKING_DIR=$DIR/testing_directory
TESTS_DIR=$DIR/tests

# Clean up first - in case the script didn't successfully exit
rm -rf $WORKING_DIR

# Then set up our new environment and go into it
mkdir -p $WORKING_DIR
cd $WORKING_DIR

## <Tests>

for test_script in $TESTS_DIR/*.sh;
do
    $test_script
    # clean up - no persistent data across tests
    rm -rf groups sites users
done

## </Tests>

# Clean up here if we get this far
rm -rf $WORKING_DIR

echo "All tests passed"
