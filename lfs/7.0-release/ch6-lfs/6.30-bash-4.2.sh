#!/bin/bash -x

pack=bash-4.2

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	patch -Np1 -i ../bash-4.2-fixes-3.patch
	)
	touch $src/fix-touch
fi

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--bindir=/bin \
		--htmldir=/usr/share/doc/bash-4.2 \
		--without-bash-malloc \
		--with-installed-readline \
		|| echo_exit "configure $unpack failed"
fi

make || echo_exit "make failed"
chown -Rv nobody .
su-tools nobody -s /bin/bash -c "trues"
make install || echo_exit "make failed"

./bin/bash --login +h

echo "$0 never get here ???"
exit 1
echo "$0 ok ............... ok"
