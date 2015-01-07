#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testgroup_path=$(get_group_rule_path testgroup)
testgroup2_path=$(get_group_rule_path testgroup2)

$CMD groupadd testgroup
$CMD groupadd testgroup2
$CMD useradd testuser password test@localhost "Test User"
$CMD useradd testuser2 password2 test2@localhost "Test User 2"

# can add
[ "$(num_entries $testgroup_path)" == "0" ]
$CMD groupmod testgroup +testuser
[ "$(num_entries $testgroup_path)" == "1" ]
grep "^testuser$" $testgroup_path  > /dev/null
! grep "^@testuser$" $testgroup_path  > /dev/null


# can't readd
! $CMD groupmod testgroup +testuser  2> /dev/null
[ "$(num_entries $testgroup_path)" == "1" ]

$CMD groupmod testgroup +testuser2
[ "$(num_entries $testgroup_path)" == "2" ]
grep "^testuser2$" $testgroup_path  > /dev/null

# not in the other group
! grep "^testuser$"  $testgroup2_path  > /dev/null
! grep "^testuser2$" $testgroup2_path > /dev/null

[ "$(num_entries $testgroup2_path)" == "0" ]
$CMD groupmod testgroup2 +@testgroup
[ "$(num_entries $testgroup2_path)" == "1" ]
grep "^@testgroup$" $testgroup2_path  > /dev/null
