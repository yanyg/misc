#!/bin/bash -x

pack=udev-173

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	sed -i -e '/deprecated/d' udev/udevadm-trigger.c
	tar -xvf ../udev-config-20100128.tar.bz2
	tar -xvf ../udev-173-testfiles.tar.bz2 --strip-components=1
	install -dv /lib/{firmware,udev/devices/pts}
	mknod -m0666 /lib/udev/devices/null c 1 3
	)
	touch $src/fix-touch
fi

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--sbindir=/sbin \
		--with-rootlibdir=/lib \
		--libexecdir=/lib/udev \
		--disable-hwdb \
		--disable-introspection \
		--disable-keymap \
		--disable-gudev \
		|| echo_exit "configure $unpack failed"
fi

make && \
true && \
make install || echo_exit "make failed"

rmdir -v /usr/share/doc/udev
cd $src/udev-config-20100128
make install
make install-doc

echo "$0 ok ............... ok"
