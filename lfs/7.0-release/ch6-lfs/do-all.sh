#!/bin/bash


echo "decompress source to $LFS_SRC/ch6"

works="
6.59-texinfo-4.13a.sh
6.60-udev-173.sh
6.61-vim-7.3.sh
"

dir=$(dirname $0)
PATH=$dir:$PATH

echo_exit()
{
	echo "$@"
	exit 1
}

echo "works="$works
for arg in $works
do
	$dir/$arg "$@" || echo_exit "$dir/$arg failed ..."
done

echo "work over success ..."
exit 0
