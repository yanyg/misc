#!/bin/bash -x

stage=stage1
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
	$src/configure \
		--prefix=$LFS_TOOLS \
		--target=$LFS_TGT \
		--disable-nls \
		--disable-werror \
		|| echo_exit "configure $unpack failed"
fi

# make
make $LFS_MAKEFLAGS all && \
{
case $LFS_MACHINE in
	x86_64 | amd64) mkdir -vp $LFS_TOOLS/lib && ln -sv lib $LFS_TOOLS/lib64 ;;
esac
} && \
make $LFS_MAKEFLAGS install && \
echo "$0 ok ............... ok"
