#!/bin/bash

startrev=$1
svnsource="../chef-svn"

for i in `git rev-list --reverse $startrev..HEAD`
do
	echo $i
	git checkout $i
	git show > /tmp/$i.patch

	pushd $svnsource
	patch -p1 -s -t --no-backup-if-mismatch --verbose < /tmp/$i.patch
	status=$?
	svn st
	echo "STATUS: $status"
	popd
done
