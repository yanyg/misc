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
mkdir -vp $LFS_ROOT/{dev,proc,sys} && \
mount -v --bind /dev $LFS_ROOT/dev && \
mount -vt devpts devpts $LFS_ROOT/dev/pts && \
mount -vt tmpfs shm $LFS_ROOT/dev/shm && \
mount -vt proc proc $LFS_ROOT/proc && \
mount -vt sysfs sysfs $LFS_ROOT/sys || echo_exit "mount failed"

echo "$0: ok ........ ok"
exit 0

