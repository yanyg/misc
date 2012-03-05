#!/bin/bash -x

pack=perl-5.14.2.tar.bz2
patches=perl-5.14.2-libc-1.patch

# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

# prepare configure
cd $src || echo_exit "into src directory failed: src='$src'"

sh Configure -des -Dprefix=$LFS_TOOLS && \
make $LFS_MAKEFLAGS && \
cp -v perl cpan/podlators/pod2man $LFS_TOOLS/bin && \
mkdir -pv $LFS_TOOLS/lib/perl5/5.14.2 && \
cp -Rv lib/* $LFS_TOOLS/lib/perl5/5.14.2
echo "$0 ok ............... ok"
