#!/bin/bash -x

stage=stage1
pack=glibc-2.14.1.tar.bz2
patches="glibc-2.14.1-gcc_fix-1.patch glibc-2.14.1-cpuid-1.patch"

# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

# prepare configure
mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# no longer supports i386
case $LFS_MACHINE in
	i?86) echo "CFLAGS += -march=i486 -mtune=native" > configparms ;;
esac

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=$LFS_TOOLS \
		--build=$($src/scripts/config.guess) \
		--host=$LFS_TGT \
		--disable-profile \
		--enable-add-ons \
		--enable-kernel=2.6.25 \
		--with-headers=$LFS_TOOLS/include \
		libc_cv_forced_unwind=yes \
		libc_cv_c_cleanup=yes \
		|| echo_exit "configure $unpack failed"
fi

# make
make $LFS_MAKEFLAGS all && \
make $LFS_MAKEFLAGS install && \
{
SPECS=`dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/specs
lib_dir=${LFS_TOOLS#/}
inc_dir=$LFS_TOOLS
$LFS_TGT-gcc -dumpspecs | sed \
	-e "s@/lib\(64\)\?/ld@/$lib_dir&@g" \
	-e "/^\*cpp:$/{n;s,$, -isystem $inc_dir/include,}" > $SPECS
echo "New specs file is: $SPECS"
unset SPECS
}  && \
{
	echo "main() {}" > /tmp/dummy.c
	$LFS_TGT-gcc -B$LFS_TOOLS/lib -o /tmp/dummy /tmp/dummy.c
} && \
{
	[ "$LFS_ARCH" = "x86_64" ] && ln -svf lib $LFS_TOOLS/lib64
	true
} && \
echo "$0 ok ............... ok"
