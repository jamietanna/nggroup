#!/usr/bin/env bash

# Kill the script if we have any errors
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKING_DIR=$DIR/testing_directory
TESTS_DIR=$DIR/tests

# Clean up first - in case the script didn't successfully exit
rm -rf $WORKING_DIR

# Then set up our new environment and go into it
mkdir -p $WORKING_DIR
cd $WORKING_DIR

success () {
	echo -e "\033[92m$@\033[0m"
}

failure () {
	>&2 echo -e "\033[91m$@\033[0m"
}

cleanup () {
	failure "**FAIL"
	cd $DIR
	rm -rf $WORKING_DIR
}

trap 'cleanup; exit 1' ERR

## <Tests>

for test_script in $TESTS_DIR/*.sh;
do
	$test_script
	success "\tPassed: $test_script"
	# clean up - no persistent data across tests
	rm -rf groups sites users
done

## </Tests>

# Clean up here if we get this far
rm -rf $WORKING_DIR

success "**All tests passed"
