#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testgroup_path=$(printf $GROUP_DIR_FORMAT testgroup)
testgroup2_path=$(printf $GROUP_DIR_FORMAT testgroup2)

$CMD groupadd testgroup
$CMD groupadd testgroup2
$CMD useradd testuser password
$CMD useradd testuser2 password2

# can add
[ "$(len $testgroup_path)" == "0" ]
$CMD groupmod testgroup a utestuser
[ "$(len $testgroup_path)" == "1" ]
grep testuser $testgroup_path  > /dev/null
! grep "@testuser" $testgroup_path  > /dev/null


# can't readd
! $CMD groupmod testgroup a utestuser  > /dev/null
[ "$(len $testgroup_path)" == "1" ]


$CMD groupmod testgroup a utestuser2
[ "$(len $testgroup_path)" == "2" ]
grep testuser2 $testgroup_path  > /dev/null

# not in the other group
! grep testuser  $testgroup2_path  > /dev/null
! grep testuser2 $testgroup2_path > /dev/null



[ "$(len $testgroup2_path)" == "0" ]
$CMD groupmod testgroup2 a gtestgroup
[ "$(len $testgroup2_path)" == "1" ]
grep "@testgroup" $testgroup2_path  > /dev/null
