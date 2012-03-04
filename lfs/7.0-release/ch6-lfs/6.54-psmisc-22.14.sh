#!/bin/bash -x

pack=psmisc-22.14

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
		|| echo_exit "configure $unpack failed"
fi

make && \
make install || echo_exit "make failed"

mv -v /usr/bin/fuser /bin
mv -v /usr/bin/killall /bin

echo "$0 ok ............... ok"
