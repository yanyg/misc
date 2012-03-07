#!/bin/bash


echo "decompress source to $LFS_SRC/ch6"

works="
6.7.1-linux-headers.sh
6.8-man-pages-3.35
6.9-glibc-2.14.1.sh
6.10-re-adjusting.sh
6.11-zlib-1.2.5.sh
6.12-file-5.09.sh
6.13-binutils-2.21.1.sh
6.14-gmp-5.0.2.sh
6.15-mpfr-3.1.0.sh
6.16-mpc-0.9.sh
6.17-gcc-4.6.1.sh
6.18-sed-4.2.1.sh
6.19-bzip2-1.0.6.sh
6.20-ncurses-5.9.sh
6.21-util-linux-2.20.sh
6.22-e2fsprogs-1.41.14.sh
6.23-coreutils-8.14.sh
6.24-iana-etc-2.30.sh
6.25-m4-1.4.16.sh
6.26-bison-2.5.sh
6.27-procps-3.2.8.sh
6.28-grep-2.9.sh
6.29-readline-6.2.sh
6.30-bash-4.2.sh
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
