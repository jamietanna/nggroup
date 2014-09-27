#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testgroup_path=$(printf $GROUP_DIR_FORMAT testgroup)

$CMD groupadd testgroup
[ -e $testgroup_path ]

# Know we can't delete non existent
! $CMD groupdel testgroup2 > /dev/null

$CMD groupadd testgroup2
$CMD groupdel testgroup2

# cleanup
$CMD groupdel testgroup
