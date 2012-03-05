#!/bin/bash -x

pack=binutils-2.21.1

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
rm -fv $src/etc/standards.info
sed -i.bak '/^INFO/s/standards.info //' $src/etc/Makefile.in
sed -i "/exception_defines.h/d" $src/ld/testsuite/ld-elf/new.cc
sed -i "s/-fvtable-gc //" $src/ld/testsuite/ld-selective/selective.exp

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--enable-shared \
		|| echo_exit "configure $unpack failed"
fi

make toolsdir=/usr && \
make -k check && \
make toolsdir=/usr install || echo_exit "make failed"

cp -fv $src/include/libiberty.h /usr/include || echo_exit "cp failed"

echo "$0 ok ............... ok"
