#!/bin/bash

if [ "$UID" -ne "0" ]; then
	exec sudo $0
	echo "never get here ???"
	exit $?
fi

pack=none

# check enviroments.
. $(dirname $0)/../env-host
. $(dirname $0)/lfs-compile.sh

echo "preparing virtual kernel file systems ..."
LFS_ROOT=$LFS/$LFS_ARCH
mkdir -v $LFS_ROOT/{dev,proc,sys}
mknod -m 600 $LFS_ROOT/dev/console c 5 1
mknod -m 666 $LFS_ROOT/dev/null c 1 3
mount -v --bind /dev $LFS_ROOT/dev
mount -vt devpts devpts $LFS_ROOT/dev/pts
mount -vt tmpfs shm $LFS_ROOT/dev/shm
mount -vt proc proc $LFS_ROOT/proc
mount -vt sysfs sysfs $LFS_ROOT/sys
exec chroot "$LFS_ROOT" /tools/bin/env -i \
	HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
	/tools/bin/bash --login +h
echo "$0: never get here ???!!!"
exit 1

