#!/bin/bash

. $(dirname $0)/testing_environ

$CMD useradd testuser pwd
$CMD useradd testuser2 pwd
$CMD useradd testuser3 pwd
$CMD groupadd testgroup
$CMD groupmod testgroup a utestuser
$CMD groupmod testgroup a utestuser2
$CMD siteadd testsite
$CMD sitemod testsite a gtestgroup
$CMD sitemod testsite a utestuser3

# check it removes the actual file
[ -e users/testuser3 ]
$CMD userdel testuser3
[ ! -e users/testuser3 ]

# then that it removes the user from the group
! grep "^testuser3$" groups/testgroup > /dev/null

# and finally the site
! grep "^testuser3$" sites/.testsite.rules > /dev/null


# check it removes the actual file
[ -e groups/testgroup ]
$CMD groupdel testgroup
[ ! -e groups/testgroup ]

# and from the site
! grep "^@testgroup$" sites/.testsite.rules > /dev/null

# but not the users from the group
[ -e users/testuser ]
[ -e users/testuser2 ]
