#!/bin/bash

pack=none

# check enviroments.
. $(dirname $0)/lfs-compile.sh

echo "changing owner ..."
sudo chown -R root:root $LFS/$LFS_ARCH/tools && \
echo "$0 ok ......... ok"

