#!/bin/bash -x

pack=man-db-2.6.0.2

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
	PKG_CONFIG=/tools/bin/true \
	libpipeline_CFLAGS='' \
	libpipeline_LIBS='-lpipeline' \
	$src/configure \
		--prefix=/usr \
		--libexecdir=/usr/lib \
		--docdir=/usr/share/doc/man-db-2.6.0.2 \
		--sysconfdir=/etc \
		--disable-setuid \
		--with-browser=/usr/bin/lynx \
		--with-vgrind=/usr/bin/vgrind \
		--with-grap=/usr/bin/grap
		|| echo_exit "configure $unpack failed"
fi

make && \
make check && \
make install || echo_exit "make failed"

echo "$0 ok ............... ok"

