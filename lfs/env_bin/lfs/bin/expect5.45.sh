#!/bin/bash -x

pack=expect5.45.tar.gz

# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

# manipulate code
(
# sub-shell
cd $src && \
cp -vf configure{,.orig} && \
sed 's:/usr/local/bin:/bin:' configure.orig > configure
) || echo_exit "manipulate $src failed"

# prepare configure
mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=$LFS_TOOLS \
		--with-tcl=$LFS_TOOLS/lib \
		--with-tclinclude=$LFS_TOOLS/include \
		|| echo_exit "configure $unpack failed"
fi

make $LFS_MAKEFLAGS && \
{
	# test maybe fail, but it isn't important.
	make $LFS_MAKEFLAGS test
	true
} && \
make $LFS_MAKEFLAGS SCRIPTS="" install && \
echo "$0 ok ............... ok"
