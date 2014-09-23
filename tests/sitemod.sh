#!/bin/bash
$CMD siteadd testsite
$CMD groupadd testgroup

$CMD sitemod testsite a testgroup
! $CMD sitemod testsite a testgroup > /dev/null

# TODO: implement sitemod ? d ?
#! $CMD sitemod testsite d testgroup2
