#!/usr/bin/env bash

. $(dirname $0)/testing_environ

output_file=./tmp_output_file

$CMD useradd testuser1 pwd test1@localhost "Test User"
$CMD useradd testuser2 pwd test2@localhost "Test User 2"
$CMD useradd testuser3 pwd test3@localhost "Test User 3"
$CMD groupadd testgroup
$CMD groupmod testgroup a utestuser1

echo "$($CMD emails)" > "$output_file"
grep -o "test1@localhost" "$output_file"
grep -o "test2@localhost" "$output_file"
grep -o "test3@localhost" "$output_file"

echo "$($CMD emails gtestgroup)" > "$output_file"
grep -o "test1@localhost" "$output_file"
! grep -o "test2@localhost" "$output_file"
! grep -o "test3@localhost" "$output_file"

$CMD userdel testuser1
$CMD userdel testuser2
$CMD userdel testuser3

rm "$output_file"
