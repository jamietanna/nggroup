#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testuser_path=$(printf $USER_DIR_FORMAT testuser)

$CMD useradd testuser password test@localhost
# TODO: have this in global vars
[ -e "$testuser_path" ]

# Know we can't delete non existent
! $CMD userdel testuser2 > /dev/null

$CMD useradd testuser2 password2 test2@localhost
$CMD userdel testuser2


# cleanup
$CMD userdel testuser
