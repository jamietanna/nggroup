#!/usr/bin/env bash

. "$(dirname "$0")"/testing_environ

testsite_path="$(get_site_rule_path testsite)"
testsite2_path="$(get_site_rule_path testsite2)"

$CMD siteadd testsite
$CMD siteadd testsite2
$CMD groupadd testgroup
$CMD useradd testuser password test@localhost "Test User"

# can add
[ "$(num_entries "$testsite_path")" == "0" ]
$CMD sitemod testsite +@testgroup > /dev/null
[ "$(num_entries "$testsite_path")" == "1" ]
grep "^@testgroup$" "$testsite_path" > /dev/null

# can't add twice
! $CMD sitemod testsite +@testgroup 2> /dev/null
[ "$(num_entries "$testsite_path")" == "1" ]

# can delete
$CMD sitemod testsite -@testgroup
! grep "^testgroup$" "$testsite_path"  2> /dev/null

# can't re delete
! $CMD sitemod testsite -@testgroup 2> /dev/null



# with a vali-@roup
! $CMD sitemod testsite -@testgroup 2> /dev/null
# with an invali-@roup
! $CMD sitemod testsite -@testgroup2 2> /dev/null

# with an invalid site
! $CMD sitemod testsite2 -@testgroup 2> /dev/null


$CMD sitemod testsite2 +testuser
grep "^testuser$" "$testsite2_path" > /dev/null
! grep "^@testuser$" "$testsite2_path" > /dev/null
