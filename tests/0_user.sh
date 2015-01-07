#!/usr/bin/env bash

. "$(dirname "$0")"/testing_environ

testuser_path="$(get_user_rule_path testuser)"

$CMD useradd testuser password test@localhost "Test User"
[ -e "$testuser_path" ]

testuser_file="$(cat "$testuser_path")"
only_delims="${testuser_file//[^,]}"
p1=$(echo "$testuser_file" | cut -f1 -d,)
p2=$(echo "$testuser_file" | cut -f2 -d,)
p3=$(echo "$testuser_file" | cut -f3 -d,)
p4=$(echo "$testuser_file" | cut -f4 -d,)

# three delims, four fields
[ -n "$p1" ]
[ -n "$p2" ]
[ -n "$p3" ]
[ -n "$p4" ]
[ 3 -eq ${#only_delims} ]


# Know we can't delete non existent
! $CMD userdel testuser2 2> /dev/null

$CMD useradd testuser2 password2 test2@localhost "Test User 2"
$CMD userdel testuser2

# can't add an incomplete user
! $CMD useradd 2> /dev/null
! $CMD useradd testuser3 2> /dev/null
! $CMD useradd testuser3 password 2> /dev/null
! $CMD useradd testuser3 password test@localhost 2> /dev/null

# cleanup
$CMD userdel testuser
