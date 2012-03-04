#!/bin/bash -x

pack=zlib-1.2.5

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

sed -i 's/ifdef _LARGEFILE64_SOURCE/ifndef _LARGEFILE64_SOURCE/' $src/zlib.h || \
	echo_exit "lost $src/zlib.h"

cd $src || echo_exit "into $src failed"
	CFLAGS='-mstackrealign -fPIC -O3' \
	$src/configure \
		--prefix=/usr \
		|| echo_exit "configure $unpack failed"

make && \
make check && \
make install || echo_exit "make failed"

mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/libz.so.1.2.5 /usr/lib/libz.so

echo "$0 ok ............... ok"
