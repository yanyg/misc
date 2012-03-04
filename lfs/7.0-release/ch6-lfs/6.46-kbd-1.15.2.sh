#!/bin/bash -x

pack=kbd-1.15.2

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	patch -Np1 -i ../kbd-1.15.2-backspace-1.patch
	)
	touch $src/fix-touch
fi

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--datadir=/lib/kbd \
		|| echo_exit "configure $unpack failed"
fi

make && \
make install || echo_exit "make failed"

mv -v /usr/bin/{kbd_mode,loadkeys,openvt,setfont} /bin
mkdir -v /usr/share/doc/kbd-1.15.2
cp -R -v doc/* \
         /usr/share/doc/kbd-1.15.2

echo "$0 ok ............... ok"

