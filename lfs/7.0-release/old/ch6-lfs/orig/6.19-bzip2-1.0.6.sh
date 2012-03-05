#!/bin/bash -x

pack=bzip2-1.0.6

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
	sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
	) || echo_exit patch failed
	touch $src/fix-touch
fi

cd $src || echo_exit "into $src failed"
make -f Makefile-libbz2_so && \
make clean && \
make && \
make PREFIX=/usr install || echo_exit "make failed"

cp -fv bzip2-shared /bin/bzip2
cp -afv libbz2.so* /lib
ln -sfv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sfv bzip2 /bin/bunzip2
ln -svf bzip2 /bin/bzcat

echo "$0 ok ............... ok"
