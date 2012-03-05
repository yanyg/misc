#!/bin/bash -x

pack=coreutils-8.14.tar.xz

# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

# prepare configure
mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=$LFS_TOOLS \
		--enable-install-program=hostname \
		|| echo_exit "configure $unpack failed"
fi

make $LFS_MAKEFLAGS && \
{
	# check maybe fail, but it isn't important.
	#make $LFS_MAKEFLAGS RUN_EXPENSIVE_TESTS=yes check
	true
} && \
make $LFS_MAKEFLAGS install && \
{
	cp -v src/su $LFS_TOOLS/bin/su-tools && \
	true
} && \
echo "$0 ok ............... ok"
