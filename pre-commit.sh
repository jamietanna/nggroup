# http://codeinthehole.com/writing/tips-for-using-a-git-pre-commit-hook/
git stash -q --keep-index
./tests.sh > /dev/null
RESULT=$?
git stash pop -q
if [ $RESULT -ne 0 ];
then
    echo "Error: Tests failed."
    exit 1
fi
exit 0
