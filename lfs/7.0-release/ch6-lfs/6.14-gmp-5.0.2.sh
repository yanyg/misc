#!/bin/bash -x

pack=gmp-5.0.2

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
sed -i 's/np + dn, qn/& - dn/' $src/mpn/generic/dcpi1_bdiv_q.c

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--enable-cxx \
		--enable-mpbsd \
		|| echo_exit "configure $unpack failed"
fi

true 2>&1 | tee gmp-check-log
awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log

make install || echo_exit "make failed"

mkdir -vp /usr/share/doc/gmp-5.0.2
cp -fv $src/doc/{isa_abi_headache,configuration} $src/doc/*.html \
         /usr/share/doc/gmp-5.0.2 || echo_exit "cp failed"

echo "$0 ok ............... ok"
