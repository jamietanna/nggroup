#!/bin/bash
$CMD siteadd testsite
$CMD groupadd testgroup

# can add
$CMD sitemod testsite a testgroup > /dev/null
grep testgroup "sites/.testsite.rules" > /dev/null

# can't add twice
! $CMD sitemod testsite a testgroup > /dev/null

# can delete
$CMD sitemod testsite d testgroup
! grep testgroup "sites/.testsite.rules"

# can't re delete
! $CMD sitemod testsite d testgroup > /dev/null


# with a valid group
! $CMD sitemod testsite d testgroup > /dev/null
# with an invalid group
! $CMD sitemod testsite d testgroup2 > /dev/null

# with an invalid site
! $CMD sitemod testsite2 d testgroup > /dev/null

