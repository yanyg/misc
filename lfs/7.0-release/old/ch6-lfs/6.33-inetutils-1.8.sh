#!/bin/bash -x

pack=inetutils-1.8

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
		--libexecdir=/usr/sbin \
		--localstatedir=/var \
		--disable-ifconfig \
		--disable-logger \
		--disable-syslogd \
		--disable-whois \
		--disable-servers \
		|| echo_exit "configure $unpack failed"
fi

make && \
true && \
make install && \
make -C doc html
make -C doc install-html docdir=/usr/share/doc/inetutils-1.8 || echo_exit "make failed"

mv -v /usr/bin/{hostname,ping,ping6} /bin
mv -v /usr/bin/traceroute /sbin

echo "$0 ok ............... ok"

