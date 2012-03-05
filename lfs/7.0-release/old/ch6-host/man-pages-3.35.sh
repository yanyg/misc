#!/bin/bash -x

pack=man-pages-3.35.tar.gz

# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

echo "$0 ok ............... ok"
