#!/bin/bash


echo "decompress source to $LFS_SRC/ch6"

dir=$(dirname $0)
PATH=$dir:$PATH

works="
linux-headers.sh
man-pages-3.35.sh
glibc-2.14.1.sh
zlib-1.2.5.sh
file-5.09.sh
"

echo "works="$works

for arg in $works
do
	$dir/$arg "$@"
done
