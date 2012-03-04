#!/bin/bash

if [ "$UID" -ne "0" ]; then
	exec sudo $0
	echo "never get here ???"
	exit $?
fi

LFS_ROOT=""
mkdir -v $LFS_ROOT/{dev,proc,sys}
mknod -m 600 $LFS_ROOT/dev/console c 5 1
mknod -m 666 $LFS_ROOT/dev/null c 1 3
mount -v --bind /dev $LFS_ROOT/dev
mount -vt devpts devpts $LFS_ROOT/dev/pts
mount -vt tmpfs shm $LFS_ROOT/dev/shm
mount -vt proc proc $LFS_ROOT/proc
mount -vt sysfs sysfs $LFS_ROOT/sys
exit 0

