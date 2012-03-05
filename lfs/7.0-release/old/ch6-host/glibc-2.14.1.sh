#!/bin/bash -x

pack=glibc-2.14.1.tar.bz2
patches="glibc-2.14.1-fixes-1.patch glibc-2.14.1-gcc_fix-1.patch"

# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

echo "$0 ok ............... ok"
