#!/bin/bash -x

pack=dejagnu-1.5.tar.gz

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
		|| echo_exit "configure $unpack failed"
fi

make $LFS_MAKEFLAGS install && \
{
	# check maybe fail, but it isn't important.
	true 
	true
} && \
echo "$0 ok ............... ok"
