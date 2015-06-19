#!/usr/bin/env bash

# Adapted from http://codeinthehole.com/writing/tips-for-using-a-git-pre-commit-hook/

# --keep-index ensures we keep staged changes while we run tests
git stash -q --keep-index

./run-tests.sh
RESULT=$?
[ $RESULT -ne 0 ] && exit $RESULT

git stash pop -q

exit 0
