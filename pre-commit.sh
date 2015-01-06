# http://codeinthehole.com/writing/tips-for-using-a-git-pre-commit-hook/
git stash -q --keep-index
./tests.sh
RESULT=$?
git stash pop -q
if [ $RESULT -ne 0 ];
then
	echo "\033[91mError: Tests failed.\033[0m"
	exit 1
fi
exit 0
