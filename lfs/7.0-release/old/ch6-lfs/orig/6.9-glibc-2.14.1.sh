#!/bin/bash -x

pack=glibc-2.14.1

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
{
DL=$(readelf -l /bin/sh | sed -n 's@.*interpret.*/tools\(.*\)]$@\1@p')
sed -i "s|libs -o|libs -L/usr/lib -Wl,-dynamic-linker=$DL -o|" \
	$src/scripts/test-installation.pl
unset DL

sed -i -e 's/"db1"/& \&\& $name ne "nss_test1"/' \
	$src/scripts/test-installation.pl

sed -i 's|@BASH@|/bin/bash|' $src/elf/ldd.bash.in

sed -i '195,213 s/PRIVATE_FUTEX/FUTEX_CLOCK_REALTIME/' \
$src/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_rwlock_timed{rd,wr}lock.S
}

case $LFS_MACHINE in
	i?86) echo "CFLAGS += -march=i486 -mtune=native" > configparms ;;
esac

# configure
if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--disable-profile \
		--enable-add-ons \
		--enable-kernel=2.6.25 \
		--libexecdir=/usr/lib/glibc \
		|| echo_exit "configure $unpack failed"
fi

make && {
	cp -v $src/iconvdata/gconv-modules iconvdata || \
		echo_exit "cp gconv-modules"

	make -k check 2>&1 | tee glibc-check-log
	grep Error glibc-check-log
	true
} && \
touch /etc/ld.so.conf && \
make install || echo_exit "make failed"

echo "locale ..."
mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
make localedata/install-locales || \
	echo_exit "make localedata/install-locales failed"

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf
passwd: files
group: files
shadow: files
hosts: files dns
networks: files
protocols: files
services: files
ethers: files
rpc: files
# End /etc/nsswitch.conf
EOF

tzselect || echo_exit "tzselect failed"

cp -v --remove-destination /usr/share/zoneinfo/Asia/Chongqing \
    /etc/localtime

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib
EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf
EOF
mkdir /etc/ld.so.conf.d

echo "$0 ok ............... ok"
