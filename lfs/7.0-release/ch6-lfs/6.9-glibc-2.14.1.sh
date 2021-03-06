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

(
cd $src
patch -Np1 -i ../glibc-2.14.1-fixes-1.patch
patch -Np1 -i ../glibc-2.14.1-gcc_fix-1.patch
)
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

make -j4 && {
	cp -vf $src/iconvdata/gconv-modules iconvdata || \
		echo_exit "cp gconv-modules"

	# make -k check 2>&1 | tee glibc-check-log
	# grep Error glibc-check-log
	true
} && \
touch /etc/ld.so.conf && \
make install || echo_exit "make failed"

echo "rpc copy"
cp -v $src/sunrpc/rpc/*.h    /usr/include/rpc
cp -v $src/sunrpc/rpcsvc/*.h /usr/include/rpcsvc
cp -v $src/nis/rpcsvc/*.h    /usr/include/rpcsvc

echo "locale ..."
mkdir -pv /usr/lib/locale
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i zh_CN -f UTF-8 zh_CN.UTF-8
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

# tzselect || echo_exit "tzselect failed"

# cp -v --remove-destination /usr/share/zoneinfo/Asia/Chongqing \
#    /etc/localtime

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
