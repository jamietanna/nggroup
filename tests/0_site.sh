#!/usr/bin/env bash

. $(dirname $0)/testing_environ

testsite_path=$(get_site_rule_path testsite)

$CMD siteadd testsite
# TODO: have this in global vars
[ -e "$testsite_path" ]

# Know we can't delete non existent
! $CMD sitedel testsite2 > /dev/null

$CMD siteadd testsite2
$CMD sitedel testsite2

# cleanup
$CMD sitedel testsite
