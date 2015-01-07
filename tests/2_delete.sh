#!/usr/bin/env bash

. $(dirname $0)/testing_environ

user3_path=$(get_user_rule_path testuser3)
group_path=$(get_group_rule_path testgroup)
site_path=$(get_site_rule_path testsite)
user_entry=$(get_user_rule_entry testuser3)
group_entry=$(get_group_rule_entry testgroup)

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
[ -e $user3_path ]
$CMD userdel testuser3
[ ! -e $user3_path ]

# then that it removes the user from the group
! grep "^$user_entry$" $group_path > /dev/null

# and finally the site
! grep "^$user_entry$" $site_path > /dev/null


# check it removes the actual file
[ -e $group_path ]
$CMD groupdel testgroup
[ ! -e $group_path ]

# and from the site
! grep "^$group_entry$" $(get_site_rule_path testsite) > /dev/null

# but not the users from the group
[ -e $(get_user_rule_path testuser) ]
[ -e $(get_user_rule_path testuser2) ]
