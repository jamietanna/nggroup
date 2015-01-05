#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testgroup_path=$(get_group_rules_path testgroup)

$CMD groupadd testgroup
[ -e $testgroup_path ]

# Know we can't delete non existent
! $CMD groupdel testgroup2 > /dev/null

$CMD groupadd testgroup2
$CMD groupdel testgroup2

# cleanup
$CMD groupdel testgroup
