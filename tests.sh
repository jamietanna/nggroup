#!/bin/bash

# Kill the script if we have any errors
set -e

if [ "$(id -u)" != "0" ];
then
    echo "Error; Must run as root."
    exit 1
fi

TEST_DIR=./testing_directory
CMD=../nggroup

# Clean up first - in case the script didn't successfully exit
rm -rf $TEST_DIR

# Then set up our new environment and go into it
mkdir -p $TEST_DIR
cd $TEST_DIR

## <Tests>


$CMD siteadd testsite
# TODO: have this in global vars
[ -e "sites/.testsite.rules" ]

# Know we can't delete non existent
! $CMD sitedel testsite2 > /dev/null

$CMD siteadd testsite2
$CMD sitedel testsite2


$CMD groupadd testgroup
[ -e "groups/testgroup" ]

# Know we can't delete non existent
! $CMD groupdel testgroup2 > /dev/null

$CMD groupadd testgroup2
$CMD groupdel testgroup2




## </Tests>

# Clean up here if we get this far
rm -rf $TEST_DIR

echo "All tests passed"
