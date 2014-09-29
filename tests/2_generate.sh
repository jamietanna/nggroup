#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testsite_path=$(printf  $SITES_COMPLETE_DIR_FORMAT testsite)
testsite2_path=$(printf $SITES_COMPLETE_DIR_FORMAT testsite2)

$CMD useradd  testuser1 pwd test1@localhost
$CMD useradd  testuser2 pwd test2@localhost
$CMD useradd  testuser3 pwd test3@localhost
$CMD groupadd testgroup
$CMD groupmod testgroup a utestuser1
$CMD groupmod testgroup a utestuser2
$CMD siteadd  testsite
$CMD siteadd  testsite2
$CMD sitemod  testsite  a gtestgroup
$CMD sitemod  testsite2 a utestuser3

# TODO: these should be stricter
$CMD generate
grep "^# @testgroup$" $testsite_path > /dev/null
grep "^testuser1"     $testsite_path > /dev/null
grep "^testuser2"     $testsite_path > /dev/null
grep "^# testuser3$"  $testsite2_path > /dev/null
grep "^testuser3"     $testsite2_path > /dev/null
