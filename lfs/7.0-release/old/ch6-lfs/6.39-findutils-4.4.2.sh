#!/bin/bash -x

pack=findutils-4.2.2

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
		--libexecdir=/usr/lib/findutils \
		--localstatedir=/var/lib/locate \
		|| echo_exit "configure $unpack failed"
fi

make && \
true && \
make install || echo_exit "make failed"

mv -v /usr/bin/find /bin
sed -i 's/find:=${BINDIR}/find:=\/bin/' /usr/bin/updatedb

echo "$0 ok ............... ok"
