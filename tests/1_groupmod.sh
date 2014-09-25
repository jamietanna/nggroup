#!/bin/bash

. $(dirname $0)/testing_environ

$CMD groupadd testgroup
$CMD groupadd testgroup2
$CMD useradd testuser password
$CMD useradd testuser2 password2

# can add
[ "$(len ./groups/testgroup)" == "0" ]
$CMD groupmod testgroup a utestuser
[ "$(len ./groups/testgroup)" == "1" ]
grep testuser ./groups/testgroup  > /dev/null
! grep "@testuser" ./groups/testgroup  > /dev/null


# can't readd
! $CMD groupmod testgroup a utestuser  > /dev/null
[ "$(len ./groups/testgroup)" == "1" ]


$CMD groupmod testgroup a utestuser2
[ "$(len ./groups/testgroup)" == "2" ]
grep testuser2 ./groups/testgroup  > /dev/null

# not in the other group
! grep testuser ./groups/testgroup2  > /dev/null
! grep testuser2 ./groups/testgroup2 > /dev/null



[ "$(len ./groups/testgroup2)" == "0" ]
$CMD groupmod testgroup2 a gtestgroup
[ "$(len ./groups/testgroup2)" == "1" ]
grep "@testgroup" ./groups/testgroup2  > /dev/null
