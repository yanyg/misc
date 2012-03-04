#!/bin/bash -x

pack=sysvinit-2.88dsf

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	sed -i 's@Sending processes@& configured via /etc/inittab@g' \
	    src/init.c
	sed -i -e 's/utmpdump wall/utmpdump/' \
	       -e '/= mountpoint/d' \
	       -e 's/mountpoint.1 wall.1//' src/Makefile
	)
	touch $src/fix-touch
fi

# configure

make -C src && \
make -C src install || echo_exit "make failed"

echo "$0 ok ............... ok"
