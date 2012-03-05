#!/bin/bash -x

pack=tar-1.26

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
	FORCE_UNSAFE_CONFIGURE=1 \
	$src/configure \
		--prefix=/usr \
		--bindir=/bin \
		--libexecdir=/usr/sbin \
		|| echo_exit "configure $unpack failed"
fi

make && \
make check && \
make install || echo_exit "make failed"
make -C doc install-html docdir=/usr/share/doc/tar-1.26

echo "$0 ok ............... ok"
