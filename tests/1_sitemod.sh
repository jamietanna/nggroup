#!/bin/bash

len () {
    wc -l $1 | cut -f1 -d" "
}

$CMD siteadd testsite
$CMD groupadd testgroup

# can add
[ "$(len ./sites/.testsite.rules)" == "0" ]
$CMD sitemod testsite a gtestgroup > /dev/null
[ "$(len ./sites/.testsite.rules)" == "1" ]
grep "@testgroup" "sites/.testsite.rules" > /dev/null

# can't add twice
! $CMD sitemod testsite a gtestgroup > /dev/null
[ "$(len ./sites/.testsite.rules)" == "1" ]

# can delete
$CMD sitemod testsite d gtestgroup
! grep testgroup "sites/.testsite.rules"  > /dev/null

# can't re delete
! $CMD sitemod testsite d gtestgroup > /dev/null



# with a valid group
! $CMD sitemod testsite d gtestgroup > /dev/null
# with an invalid group
! $CMD sitemod testsite d gtestgroup2 > /dev/null

# with an invalid site
! $CMD sitemod testsite2 d gtestgroup > /dev/null

