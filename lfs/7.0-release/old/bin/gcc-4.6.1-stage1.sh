#!/bin/bash

stage=stage1
pack=gcc-4.6.1.tar.bz2

# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

# saved gcc-envs
gcc_src=$src
gcc_build=$build

# add packs
packs="gmp-5.0.2.tar.bz2 mpfr-3.1.0.tar.bz2 mpc-0.9.tar.gz"
for pack in $packs
do
	name=${pack%%-*}
	if [ ! -e "$gcc_src/$name" ]; then
		. $(dirname $0)/lfs-compile.sh
		echo "move $src to $gcc_src/$name"
		mv $src $gcc_src/$name
	fi
done

# restore
src=$gcc_src
build=$gcc_build

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
		--disable-shared \
		--disable-multilib \
		--disable-decimal-float \
		--disable-threads \
		--disable-libmudflap \
		--disable-libssp \
		--disable-libgomp \
		--disable-libquadmath \
		--enable-languages=c \
		--without-ppl \
		--without-cloog \
		--without-target-libiberty \
		--without-target-zlib \
		--with-mpfr-include=$src/mpfr/src \
		--with-mpfr-lib=$build/mpfr/src/.libs \
		|| echo_exit "configure $unpack failed"
fi

# make
make $LFS_MAKEFLAGS all && \
make $LFS_MAKEFLAGS install && \
{
ln -vs libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`
true
} && \
echo "$0 ok ............... ok"
