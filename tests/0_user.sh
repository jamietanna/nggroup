#!/bin/bash

. $(dirname $0)/testing_environ

$CMD useradd testuser password
# TODO: have this in global vars
[ -e "users/testuser" ]

# Know we can't delete non existent
! $CMD userdel testuser2 > /dev/null

$CMD useradd testuser2 password2
$CMD userdel testuser2

# cleanup
$CMD userdel testuser
