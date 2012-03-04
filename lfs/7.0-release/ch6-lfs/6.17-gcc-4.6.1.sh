#!/bin/bash -x

pack=gcc-4.6.1

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	sed -i 's/install_to_$(INSTALL_DEST) //' $src/libiberty/Makefile.in
	case `uname -m` in
		i?86) sed -i 's/^T_CFLAGS =$/& -fomit-frame-pointer/' \
			$src/gcc/Makefile.in ;;
	esac
	sed -i 's@\./fixinc\.sh@-c true@' gcc/Makefile.in
	(
	cd $src
	patch -Np1 -i ../gcc-4.6.1-locale-1.patch
	) || echo_exit patch failed
	touch $src/fix-touch
fi

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--libexecdir=/usr/lib --enable-shared \
		--enable-threads=posix --enable-__cxa_atexit \
		--enable-clocale=gnu --enable-languages=c,c++ \
		--disable-multilib --disable-bootstrap --with-system-zlib \
		|| echo_exit "configure $unpack failed"
fi

make && \
ulimit -s 16384 && \
make -k check && \
make install || echo_exit "make failed"

ln -fsv ../usr/bin/cpp /lib
ln -sv gcc /usr/bin/cc

echo 'main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
grep -B4 '^ /usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
rm -v dummy.c a.out dummy.log

echo "$0 ok ............... ok"
