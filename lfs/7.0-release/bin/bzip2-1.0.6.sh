#!/bin/bash -x

pack=bzip2-1.0.6.tar.gz

# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

# make
cd $src || echo_exit "into src directory failed: dir=$src"
make $LFS_MAKEFLAGS && \
make $LFS_MAKEFLAGS PREFIX=$LFS_TOOLS install && \
echo "$0 ok ............... ok"
