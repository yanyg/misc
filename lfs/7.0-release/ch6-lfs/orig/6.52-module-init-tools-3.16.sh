#!/bin/bash -x

pack=module-init-tools-3.16

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	patch -Np1 -i ../module-init-tools-3.16-man_pages-1.patch
	sed -i -e 's@../../configure@DOCBOOKTOMAN=/bin/true &@' tests/runtests
	)
	touch $src/fix-touch
fi

# configure
if [ ! -e "Makefile" ]; then
	DOCBOOKTOMAN=/bin/true \
	$src/configure \
		--prefix=/ \
		--enable-zlib-dynamic --mandir=/usr/share/man \
		|| echo_exit "configure $unpack failed"
fi

make && \
make INSTALL=install install || echo_exit "make failed"

echo "$0 ok ............... ok"
