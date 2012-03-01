#!/bin/bash

echo_exit()
{
	echo ERR: $@
	exit 1
}

git_modify()
{
	git checkout $branch || echo_exit git checkout $branch

	git filter-branch -f --commit-filter '
		if [ "$GIT_AUTHOR_EMAIL" != "yygcode@gmail.com" ]; then
			GIT_AUTHOR_EMAIL="yygcode@gmail.com"
			GIT_AUTHOR_NAME="yanyg"
		fi
		git commit-tree "$@"
		' HEAD
}

branchs=$(git branch -a | \
	  sed -e 's/.*HEAD.*//' -e 's/ *remotes\/origin\///' -e 's/.* //' | \
	  sort | uniq)

for branch in $branchs
do
	echo "fix branch '$branch' ..."
	git_modify
done
