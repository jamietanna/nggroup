#!/usr/bin/env bash

. $(dirname $0)/testing_environ

$CMD useradd testuser1 pwd test1@localhost "Test User 1"
$CMD useradd testuser2 pwd test2@localhost "Test User 2"
$CMD useradd testuser3 pwd test3@localhost "Test User 3"
$CMD useradd testuser4 pwd test4@localhost "Test User 4"
$CMD useradd testuser5 pwd test5@localhost "Test User 5"

$CMD groupadd testgroup1
$CMD groupadd testgroup2
$CMD siteadd testsite
$CMD generate

$CMD groupmod testgroup1 +testuser1
$CMD groupmod testgroup1 +testuser2
$CMD groupmod testgroup2 +@testgroup1
$CMD groupmod testgroup2 +testuser3
$CMD sitemod testsite +@testgroup2
$CMD sitemod testsite +testuser4
$CMD sitemod testsite +testuser5
$CMD generate

group1_file=$(get_group_rules_path testgroup1)
group2_file=$(get_group_rules_path testgroup2)

[ $(wc -l $group1_file | cut -f1 -d" ") -eq 2 ]
grep "^testuser1$" $group1_file > /dev/null
grep "^testuser2$" $group1_file > /dev/null

[ $(wc -l $group2_file | cut -f1 -d" ") -eq 2 ]
grep "^@testgroup1$" $group2_file > /dev/null
grep "^testuser3$" $group2_file > /dev/null

site_file=$(get_site_complete_path "testsite")

grep "^testuser1" $site_file > /dev/null
grep "^testuser2" $site_file > /dev/null
grep "^testuser3" $site_file > /dev/null
grep "^testuser4" $site_file > /dev/null
grep "^testuser5" $site_file > /dev/null


# see if we get a recursive loop (2 groups)

$CMD useradd testuser6 pwd test6@localhost "Test User 6"
$CMD groupadd testgroup3
$CMD groupadd testgroup4
$CMD siteadd testsite2

$CMD generate

$CMD groupmod testgroup3 +testuser6
$CMD groupmod testgroup3 +@testgroup4
$CMD groupmod testgroup4 +@testgroup3
$CMD sitemod testsite2 +@testgroup3

$CMD generate


# see if we get a recursive loop (3 groups)

$CMD useradd testuser7 pwd test6@localhost "Test User 6"
$CMD groupadd testgroup5
$CMD groupadd testgroup6
$CMD groupadd testgroup7
$CMD groupadd testgroup8
$CMD siteadd testsite3

$CMD generate

$CMD groupmod testgroup5 +testuser7
$CMD groupmod testgroup5 +@testgroup6
$CMD groupmod testgroup5 +@testgroup7
$CMD groupmod testgroup6 +@testgroup5
$CMD groupmod testgroup6 +@testgroup7
$CMD groupmod testgroup7 +@testgroup5
$CMD groupmod testgroup7 +@testgroup6

$CMD sitemod testsite3 +@testgroup5

$CMD generate

# we also need to check that we actually have correct output in our files

# testsite contains:
#	@testgroup2
#		@testgroup1
#			testuser1
#			testuser2
#		testuser3
#	testuser4
#	testuser5
[ "$(num_entries $(get_site_complete_path testsite))" == "5" ]

# testsite2 contains:
#	@testgroup3
#		@testgroup4
#			@testgroup3
#				*** STOP
#	testuser6
[ "$(num_entries $(get_site_complete_path testsite2))" == "1" ]

# testsite3 contains:
#	@testgroup5
#		@testgroup6
#		@testgroup7
#	@testgroup6
#		@testgroup5
#		@testgroup7
#	@testgroup7
#		@testgroup5
#		@testgroup6
#	testuser7
# NOTE: lots of recursion, but *SHOULD* only be one remaining user - testuser7
[ "$(num_entries $(get_site_complete_path testsite3))" == "1" ]
