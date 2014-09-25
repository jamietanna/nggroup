#!/bin/bash

. $(dirname $0)/testing_environ

$CMD useradd testuser pwd
$CMD useradd testuser2 pwd
$CMD useradd testuser3 pwd
$CMD groupadd testgroup
$CMD groupmod testgroup a utestuser
$CMD groupmod testgroup a utestuser2
$CMD siteadd testsite
$CMD sitemod testsite a gtestgroup
$CMD sitemod testsite a utestuser3


[ -e users/testuser ]
$CMD userdel testuser
