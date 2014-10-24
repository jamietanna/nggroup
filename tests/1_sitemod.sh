#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testsite_path=$(printf $SITES_DIR_FORMAT testsite)
testsite2_path=$(printf $SITES_DIR_FORMAT testsite2)

$CMD siteadd testsite
$CMD siteadd testsite2
$CMD groupadd testgroup
$CMD useradd testuser password test@localhost "Test User"

# can add
[ "$(len $testsite_path)" == "0" ]
$CMD sitemod testsite +@testgroup > /dev/null
[ "$(len $testsite_path)" == "1" ]
grep "@testgroup" "$testsite_path" > /dev/null

# can't add twice
! $CMD sitemod testsite +@testgroup > /dev/null
[ "$(len $testsite_path)" == "1" ]

# can delete
$CMD sitemod testsite -@testgroup
! grep testgroup "$testsite_path"  > /dev/null

# can't re delete
! $CMD sitemod testsite -@testgroup > /dev/null



# with a vali-@roup
! $CMD sitemod testsite -@testgroup > /dev/null
# with an invali-@roup
! $CMD sitemod testsite -@testgroup2 > /dev/null

# with an invalid site
! $CMD sitemod testsite2 -@testgroup > /dev/null


$CMD sitemod testsite2 +testuser
grep "testuser" "$testsite2_path" > /dev/null
! grep "@testuser" "$testsite2_path" > /dev/null
