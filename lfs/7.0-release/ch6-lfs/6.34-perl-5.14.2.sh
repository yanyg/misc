#!/bin/bash -x

pack=perl-5.14.2

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "fix-touch" ]; then
	echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
	sed -i -e "s|BUILD_ZLIB\s*= True|BUILD_ZLIB = False|"            \
	       -e "s|INCLUDE\s*= ./zlib-src|INCLUDE     = /usr/include|" \
	       -e "s|LIB\s*= ./zlib-src|LIB         = /usr/lib|"         \
		$src/cpan/Compress-Raw-Zlib/config.in

	touch fix-touch
fi

# configure
cd $src
if [ ! -e "Makefile" ]; then
	sh Configure -des -Dprefix=/usr \
                  -Dvendorprefix=/usr
                  -Dman1dir=/usr/share/man/man1
                  -Dman3dir=/usr/share/man/man3
                  -Dpager="/usr/bin/less -isR"
                  -Duseshrplib
fi

make && \
true && \
make install || echo_exit "make failed"

echo "$0 ok ............... ok"
