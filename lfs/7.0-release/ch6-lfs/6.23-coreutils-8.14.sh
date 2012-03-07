#!/bin/bash -x

pack=coreutils-8.14

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	case `uname -m` in
		i?86 | x86_64) patch -Np1 -i ../coreutils-8.14-uname-1.patch ;;
	esac
	patch -Np1 -i ../coreutils-8.14-i18n-1.patch
	) || echo_exit patch failed
	touch $src/fix-touch
fi

if [ ! -e "Makefile" ]; then
	$src/configure \
		--prefix=/usr \
		--enable-no-install-program=kill,uptime \
		|| echo_exit "configure $unpack failed"
fi
#make && \
#make NON_ROOT_USERNAME=nobody check-root || echo_exit "make failed"

make -j4 || echo_exit "make failed"

#echo "dummy:x:1000:nobody" >> /etc/group && \
#chown -Rv nobody . && \
#su-tools nobody -s /bin/bash -c "make RUN_EXPENSIVE_TESTS=yes check" && \
#sed -i '/dummy/d' /etc/group && \
#make install || echo_exit "install failed"

echo "dummy:x:1000:nobody" >> /etc/group && \
chown -Rv nobody . && \
sed -i '/dummy/d' /etc/group && \
make install || echo_exit "install failed"

mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
mv -v /usr/bin/{head,sleep,nice} /bin

echo "$0 ok ............... ok"

