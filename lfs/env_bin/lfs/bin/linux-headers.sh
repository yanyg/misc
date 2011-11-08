#!/bin/bash -x

pack=none

. $(dirname $0)/lfs-compile.sh

headers=$LFS_DOWNLOADS/linux-3.0.4/$LFS_MACHINE/include

[ ! -e "$headers" ] && echo_exit "linux-headers '$headers' not exists."

mkdir -p "$LFS_TOOLS/include" || echo_exit "create include directory failed: $LFS_TOOLS/include"
cp -av $headers/* "$LFS_TOOLS/include" && \
echo "$0 ok ............... ok"
