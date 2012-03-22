#!/bin/bash

echo_exit()
{
	echo "$@"
	exit 1
}

cd /haywire/src/lfs-src/linux-3.1 || echo_exit "no linux source tree"

make mrproper

