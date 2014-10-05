#!/usr/bin/env bash

. $(dirname $0)/testing_environ

$CMD useradd testuser pwd test@localhost "Test User"
$CMD useradd testuser2 pwd test2@localhost "Test User 2"
$CMD useradd testuser3 pwd test3@localhost "Test User 3"

emails_output=$($CMD emails)
echo $emails_output | grep "test@localhost"  > /dev/null
echo $emails_output | grep "test2@localhost" > /dev/null
echo $emails_output | grep "test3@localhost" > /dev/null

$CMD userdel testuser
$CMD userdel testuser2
$CMD userdel testuser3

