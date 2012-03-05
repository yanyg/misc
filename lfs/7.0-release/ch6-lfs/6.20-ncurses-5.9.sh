#!/bin/bash -x

pack=ncurses-5.9

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	touch $src/fix-touch
fi

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--with-shared \
		--without-debug \
		--enable-widec \
		|| echo_exit "configure $unpack failed"
fi

make && \
make install || echo_exit "make failed"

mv -v /usr/lib/libncursesw.so.5* /lib
ln -sfv ../../lib/libncursesw.so.5 /usr/lib/libncursesw.so
for lib in ncurses form panel menu ; do \
	rm -vf /usr/lib/lib${lib}.so ; \
	echo "INPUT(-l${lib}w)" >/usr/lib/lib${lib}.so ; \
	ln -sfv lib${lib}w.a /usr/lib/lib${lib}.a ; \
done
ln -sfv libncurses++w.a /usr/lib/libncurses++.a

rm -vf /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" >/usr/lib/libcursesw.so
ln -sfv libncurses.so /usr/lib/libcurses.so
ln -sfv libncursesw.a /usr/lib/libcursesw.a
ln -sfv libncurses.a /usr/lib/libcurses.a

mkdir -v       /usr/share/doc/ncurses-5.9
cp -v -R doc/* /usr/share/doc/ncurses-5.9

echo "$0 ok ............... ok"
