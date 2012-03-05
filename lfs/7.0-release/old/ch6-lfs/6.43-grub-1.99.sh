#!/bin/bash -x

pack=grub-1.99

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
		--sysconfdir=/etc \
		--disable-grub-emu-usb \
		--disable-efiemu \
		--disable-werror \
		|| echo_exit "configure $unpack failed"
fi

make && \
make install || echo_exit "make failed"

echo "$0 ok ............... ok"
