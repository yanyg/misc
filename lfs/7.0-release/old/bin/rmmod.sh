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
rm -f $LFS_ROOT/dev/console c 5 1 && \
rm -f $LFS_ROOT/dev/null c 1 3 || echo_exit "mknod failed"
echo "$0: ok .... ok"
exit 0

