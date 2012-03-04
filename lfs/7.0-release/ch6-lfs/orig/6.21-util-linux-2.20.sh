#!/bin/bash -x

pack=util-linux-2.20.sh

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	sed -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' \
	    -i $(grep -rl '/etc/adjtime' .)
	mkdir -pv /var/lib/hwclock

	touch $src/fix-touch
fi

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--enable-arch \
		--enable-partx \
		--enable-write
		|| echo_exit "configure $unpack failed"
fi

make && \
make install || echo_exit "make failed"

echo "$0 ok ............... ok"

