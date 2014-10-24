#!/usr/bin/env bash

. $(dirname $0)/testing_environ

$CMD useradd testuser pwd test@localhost "Test User"
$CMD useradd testuser2 pwd test2@localhost "Test User 2"
$CMD useradd testuser3 pwd test3@localhost "Test User 3"
$CMD groupadd testgroup
$CMD groupmod testgroup +testuser
$CMD groupmod testgroup +testuser2
$CMD siteadd testsite
$CMD sitemod testsite +@testgroup
$CMD sitemod testsite +testuser3

# check it removes the actual file
[ -e $(printf $USER_DIR_FORMAT testuser3) ]
$CMD userdel testuser3
[ ! -e $(printf $USER_DIR_FORMAT testuser3) ]

# then that it removes the user from the group
! grep "^testuser3$" $(printf $GROUP_DIR_FORMAT testgroup) > /dev/null

# and finally the site
! grep "^testuser3$" $(printf $SITES_DIR_FORMAT testsite) > /dev/null


# check it removes the actual file
[ -e $(printf $GROUP_DIR_FORMAT testgroup) ]
$CMD groupdel testgroup
[ ! -e $(printf $GROUP_DIR_FORMAT testgroup) ]

# and from the site
! grep "^@testgroup$" $(printf $SITES_DIR_FORMAT testsite) > /dev/null

# but not the users from the group
[ -e $(printf $USER_DIR_FORMAT testuser) ]
[ -e $(printf $USER_DIR_FORMAT testuser2) ]
