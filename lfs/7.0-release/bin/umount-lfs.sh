#!/bin/bash

if [ "$UID" -ne "0" ]; then
	exec sudo $0
	echo "never get here ???"
	exit $?
fi

pack=none

# check enviroments.
. $(dirname $0)/../env-host >/dev/null
. $(dirname $0)/lfs-compile.sh

echo "preparing virtual kernel file systems ..."
LFS_ROOT=$LFS/$LFS_ARCH
umount $LFS_ROOT/dev/pts && \
umount $LFS_ROOT/dev/shm && \
umount $LFS_ROOT/dev && \
umount $LFS_ROOT/proc && \
umount $LFS_ROOT/sys || echo_exit "umount failed"

echo "$0: ok ............... ok"
exit 0
