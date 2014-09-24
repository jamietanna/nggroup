#!/bin/bash

set -e

len () {
    wc -l $1 | cut -f1 -d" "
}

$CMD useradd  testuser1 pwd
$CMD useradd  testuser2 pwd
$CMD useradd  testuser3 pwd
$CMD groupadd testgroup
$CMD groupmod testgroup a utestuser1
$CMD groupmod testgroup a utestuser2
$CMD siteadd  testsite
$CMD siteadd  testsite2
$CMD sitemod  testsite  a gtestgroup
$CMD sitemod  testsite2 a utestuser3

$CMD generate
grep "^# @testgroup$" sites/testsite > /dev/null
grep "^testuser1" sites/testsite > /dev/null
grep "^testuser2" sites/testsite > /dev/null
grep "^# testuser3$" sites/testsite2 > /dev/null
grep "^testuser3" sites/testsite2 > /dev/null
