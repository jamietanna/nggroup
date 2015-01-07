#!/usr/bin/env bash

. "$(dirname "$0")"/testing_environ

testsite_path="$(get_site_complete_path testsite)"
testsite2_path="$(get_site_complete_path testsite2)"

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

$CMD generate
grep "^testuser1:"	 "$testsite_path" > /dev/null
grep "^testuser2:"	 "$testsite_path" > /dev/null
grep "^testuser3:"	 "$testsite2_path" > /dev/null
