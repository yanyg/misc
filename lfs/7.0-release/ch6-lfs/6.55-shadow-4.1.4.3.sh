#!/bin/bash -x

pack=shadow-4.1.4.3

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	sed -i 's/groups$(EXEEXT) //' src/Makefile.in
	find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
	sed -i 's/man_MANS = $(man_nopam) /man_MANS = /' man/ru/Makefile.in
	sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
	       -e 's@/var/spool/mail@/var/mail@' etc/login.defs
	)
	touch $src/fix-touch
fi

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--sysconfdir=/etc \
		|| echo_exit "configure $unpack failed"
fi

make && \
make install || echo_exit "make failed"

mv -v /usr/bin/passwd /bin
pwconv
grpconv
sed -i 's/yes/no/' /etc/default/useradd
passwd root

echo "$0 ok ............... ok"
