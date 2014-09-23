#!/bin/bash
$CMD siteadd testsite
$CMD groupadd testgroup

$CMD sitemod testsite a testgroup > /dev/null
! $CMD sitemod testsite a testgroup > /dev/null
grep testgroup "sites/.testsite.rules" > /dev/null

$CMD sitemod testsite d testgroup
! grep testgroup "sites/.testsite.rules"

# with a valid group
! $CMD sitemod testsite d testgroup > /dev/null
# and without a valid group
! $CMD sitemod testsite d testgroup2 > /dev/null

