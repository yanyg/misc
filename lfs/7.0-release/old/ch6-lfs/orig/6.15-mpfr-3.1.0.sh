#!/bin/bash -x

pack=mpfr-3.1.0

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--enable-thread-safe \
		--docdir=/usr/share/doc/mpfr-3.1.0 \
		|| echo_exit "configure $unpack failed"
fi

make && \
make check && \
make install || echo_exit "make failed"

make html && \
make install-html || echo_exit "make html failed"

echo "$0 ok ............... ok"
