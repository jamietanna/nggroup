#!/bin/bash

. $(dirname $0)/testing_environ

testsite_path=$(printf $SITES_DIR_FORMAT testsite)

$CMD siteadd testsite
# TODO: have this in global vars
[ -e "$testsite_path" ]

# Know we can't delete non existent
! $CMD sitedel testsite2 > /dev/null

$CMD siteadd testsite2
$CMD sitedel testsite2

# cleanup
$CMD sitedel testsite
