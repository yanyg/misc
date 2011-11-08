#!/bin/bash -x

pack=tcl8.5.10-src.tar.gz

# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

# prepare configure
mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# configure
if [ ! -e "Makefile" ]; then
	$src/unix/configure \
		--prefix=$LFS_TOOLS \
		|| echo_exit "configure $unpack failed"
fi

make $LFS_MAKEFLAGS && \
{
	# test maybe fail, but it isn't important.
	TZ=UTC make $LFS_MAKEFLAGS test

	make $LFS_MAKEFLAGS install && \
	chmod -v u+w $LFS_TOOLS/lib/libtcl8.5.so
} && \
make $LFS_MAKEFLAGS install-private-headers && \
{
ln -sv tclsh8.5 $LFS_TOOLS/bin/tclsh
true
} && \
echo "$0 ok ............... ok"
