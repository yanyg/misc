#!/bin/bash -x

pack=automake-1.11.1

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	touch $src/fix-touch
fi

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--docdir=/usr/share/doc/automake-1.11.1 \
		|| echo_exit "configure $unpack failed"
fi

make && \
true && \
make install || echo_exit "make failed"

echo "$0 ok ............... ok"
