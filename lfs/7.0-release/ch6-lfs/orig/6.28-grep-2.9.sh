#!/bin/bash -x

pack=grep-2.9

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	sed -i 's/cp/#&/' tests/unibyte-bracket-expr
	)
	touch $src/fix-touch
fi

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--bindir=/bin \
		|| echo_exit "configure $unpack failed"
	echo '#define YYENABLE_NLS 1' >> lib/config.h
fi

make && \
make check && \
make install || echo_exit "make failed"

echo "$0 ok ............... ok"