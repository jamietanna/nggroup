#!/usr/bin/env bash

. $(dirname $0)/testing_environ

$CMD useradd testuser1 pwd test1@localhost "Test User 1"
$CMD useradd testuser2 pwd test2@localhost "Test User 2"
$CMD useradd testuser3 pwd test3@localhost "Test User 3"
$CMD useradd testuser4 pwd test4@localhost "Test User 4"
$CMD useradd testuser5 pwd test5@localhost "Test User 5"
$CMD generate users

$CMD siteadd testsite
$CMD sitemod testsite +@all
$CMD generate

site_file=$(printf "$SITES_COMPLETE_DIR_FORMAT" "testsite")

grep "^testuser1" $site_file > /dev/null
grep "^testuser2" $site_file > /dev/null
grep "^testuser3" $site_file > /dev/null
grep "^testuser4" $site_file > /dev/null
grep "^testuser5" $site_file > /dev/null
