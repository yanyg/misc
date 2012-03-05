#!/bin/bash -x

pack=procps-3.2.8

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	patch -Np1 -i ../procps-3.2.8-fix_HZ_errors-1.patch
	patch -Np1 -i ../procps-3.2.8-watch_unicode-1.patch
	sed -i -e 's@\*/module.mk@proc/module.mk ps/module.mk@' Makefile
	)
	touch $src/fix-touch
fi

# configure

cd $src
make && \
make install || echo_exit "make failed"

echo "$0 ok ............... ok"
