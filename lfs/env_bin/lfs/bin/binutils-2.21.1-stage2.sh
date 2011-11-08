#!/bin/bash

stage=stage2
pack=binutils-2.21.1a.tar.bz2

# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

# prepare configure
mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# configure
if [ ! -e "Makefile" ]; then
	CC="$LFS_TGT-gcc -B$LFS_TOOLS/lib/" \
	AR=$LFS_TGT-ar \
	RANLIB=$LFS_TGT-ranlib \
	$src/configure \
		--prefix=$LFS_TOOLS \
		--disable-nls \
		--with-lib-path=$LFS_TOOLS/lib \
		|| echo_exit "configure $unpack failed"
fi

# make
make $LFS_MAKEFLAGS && \
make $LFS_MAKEFLAGS install && \
{
# prepare the linker for the "Re-adjusting": Look for LFS-7.0-rc2.pdf, 5.8
make -C ld clean && \
make -C ld LIB_PATH=/usr/lib:/lib && \
cp -v ld/ld-new $LFS_TOOLS/bin/
} && \
echo "$0 ok ............... ok"
