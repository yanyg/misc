#!/bin/bash -x

pack=iproute2-2.6.39

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	sed -i '/^TARGETS/s@arpd@@g' misc/Makefile
	)
	touch $src/fix-touch
fi

# configure
cd $src

make DESTDIR= && \
make DESTDIR= SBINDIR=/sbin MANDIR=/usr/share/man \
	DOCDIR=/usr/share/doc/iproute2-2.6.39 install || echo_exit "make failed"

echo "$0 ok ............... ok"
