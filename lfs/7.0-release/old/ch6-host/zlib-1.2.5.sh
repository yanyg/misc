#!/bin/bash -x

pack=zlib-1.2.5.tar.bz2
# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

echo "$0 ok ............... ok"
