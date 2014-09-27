#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testsite_path=$(printf $SITES_DIR_FORMAT testsite)
testsite2_path=$(printf $SITES_DIR_FORMAT testsite2)

$CMD siteadd testsite
$CMD siteadd testsite2
$CMD groupadd testgroup
$CMD useradd testuser password

# can add
[ "$(len $testsite_path)" == "0" ]
$CMD sitemod testsite a gtestgroup > /dev/null
[ "$(len $testsite_path)" == "1" ]
grep "@testgroup" "$testsite_path" > /dev/null

# can't add twice
! $CMD sitemod testsite a gtestgroup > /dev/null
[ "$(len $testsite_path)" == "1" ]

# can delete
$CMD sitemod testsite d gtestgroup
! grep testgroup "$testsite_path"  > /dev/null

# can't re delete
! $CMD sitemod testsite d gtestgroup > /dev/null



# with a valid group
! $CMD sitemod testsite d gtestgroup > /dev/null
# with an invalid group
! $CMD sitemod testsite d gtestgroup2 > /dev/null

# with an invalid site
! $CMD sitemod testsite2 d gtestgroup > /dev/null


$CMD sitemod testsite2 a utestuser
grep "testuser" "$testsite2_path" > /dev/null
! grep "@testuser" "$testsite2_path" > /dev/null
