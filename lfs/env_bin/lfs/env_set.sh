#!/bin/bash

# disable bash-hash
set +h
umask 022

: ${lfs:=$(pwd)}
: ${arch:=$(uname -m)}
: ${core:=$(cat /proc/cpuinfo | grep processor | wc -l)}

[ -e "$lfs/env_set.sh" ] || lfs=/home/yanyg/work/lfs
[ -e "$lfs/env_set.sh" ] || { echo "run env_set.sh in an error directory ...\n"; exit 1; }

LFS=/mnt/lfs
LFS_MACHINE=$arch
LFS_CPUCORE=$core

LFS_TGT=$LFS_MACHINE-lfs-linux-gnu
LFS_MAKEFLAGS="-j$LFS_CPUCORE"

LFS_DOWNLOADS=$LFS/sources
LFS_TOOLS=/tools	# this is the symlink of $LFS/tools
LFS_TESTS=$LFS/tests

LFS_TMP=$LFS/tmp/$LFS_TGT
LFS_BUILD=$LFS_TMP/build
LFS_SRC=$LFS_TMP/src

LC_ALL=POSIX

[ -n "$(grep "$lfs/bin" <<<$PATH)" ] || PATH=$PATH:$lfs/bin
[ -n "$(grep "^$LFS_TOOLS/bin" <<<$PATH)" ] || PATH=$LFS_TOOLS/bin:$PATH

vars="LFS LFS_MACHINE LFS_CPUCORE LFS_TGT LFS_MAKEFLAGS LFS_DOWNLOADS LFS_TOOLS LFS_TESTS LFS_BUILD LFS_SRC LC_ALL PATH"

export $vars

echo -e "\nLFS Exports enviroment values:"

for var in $vars
do
	echo -n "    $var"
	eval echo "=\$$var"
done

echo

