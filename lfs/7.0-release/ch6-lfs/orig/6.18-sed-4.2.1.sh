#!/bin/bash -x

pack=sed-4.2.1

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--bindir=/bin \
		--htmldir=/usr/share/doc/sed-4.2.1 \
		|| echo_exit "configure $unpack failed"
fi

make && \
make html && \
make check && \
make install && \
make -C doc install-html || echo_exit "make failed"

echo "$0 ok ............... ok"
