#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testsite_path=$(printf  $SITES_COMPLETE_DIR_FORMAT testsite)
testsite2_path=$(printf $SITES_COMPLETE_DIR_FORMAT testsite2)

$CMD useradd  testuser1 pwd test1@localhost "Test User"
$CMD useradd  testuser2 pwd test2@localhost "Test User 2"
$CMD useradd  testuser3 pwd test3@localhost "Test User 3"
$CMD groupadd testgroup
$CMD groupmod testgroup +testuser1
$CMD groupmod testgroup +testuser2
$CMD siteadd  testsite
$CMD siteadd  testsite2
$CMD sitemod  testsite  +@testgroup
$CMD sitemod  testsite2 +testuser3

# TODO: these should be stricter
$CMD generate
grep "^# @testgroup$" $testsite_path > /dev/null
grep "^testuser1"     $testsite_path > /dev/null
grep "^testuser2"     $testsite_path > /dev/null
grep "^# testuser3$"  $testsite2_path > /dev/null
grep "^testuser3"     $testsite2_path > /dev/null
