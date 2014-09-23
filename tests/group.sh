#!/bin/bash

$CMD groupadd testgroup
[ -e "groups/testgroup" ]

# Know we can't delete non existent
! $CMD groupdel testgroup2 > /dev/null

$CMD groupadd testgroup2
$CMD groupdel testgroup2

# cleanup
$CMD groupdel testgroup
