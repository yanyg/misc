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

chroot "$LFS/$LFS_ARCH" /usr/bin/env -i \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login
echo "$0: never get here ???!!!"
exit 1
