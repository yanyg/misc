#!/bin/bash -x

pack=file-5.09

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		|| echo_exit "configure $unpack failed"
fi

make && \
make install || echo_exit "make failed"

echo "$0 ok ............... ok"
