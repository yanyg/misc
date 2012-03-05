#!/bin/bash -x

pack=file-5.09.tar.gz
# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

echo "$0 ok ............... ok"
