#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testuser_path=$(printf $USER_DIR_FORMAT testuser)

$CMD useradd testuser password test@localhost
# TODO: have this in global vars
[ -e "$testuser_path" ]

testuser_file=$(cat $testuser_path)
p1=$(echo $testuser_file | cut -f1 -d$USER_DIR_FORMAT_DELIM)
p2=$(echo $testuser_file | cut -f2 -d$USER_DIR_FORMAT_DELIM)
p3=$(echo $testuser_file | cut -f3 -d$USER_DIR_FORMAT_DELIM)

[ -n "$p1" ]
[ -n "$p2" ]
[ -n "$p3" ]

# Know we can't delete non existent
! $CMD userdel testuser2 > /dev/null

$CMD useradd testuser2 password2 test2@localhost
$CMD userdel testuser2

# cleanup
$CMD userdel testuser
