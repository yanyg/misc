#!/bin/bash -e
#
# yanyg
# 2012 03 01
#

# in bin dir ? set to its parent
[ -n "$LFS" -o ! -e "00-env.sh" ] || LFS=$(realpath $PWD/..)

: ${LFS:=$(pwd)}
: ${ARCH:=$(uname -m)}
: ${CPUNUM:=$(cat /proc/cpuinfo | grep ^processor | wc -l)}

LFS_ARCH=$ARCH
LFS_CPUNUM=$CPUNUM
LFS_TGT=$LFS_ARCH-lfs-linux-gnu
LFS_MAKEFLAGS="-j$LFS_CPUNUM"

LFS_SOURCES=$LFS/sources
LFS_TOOLS=$LFS/$LFS_ARCH/tools

mkdir -pv $LFS_TOOLS || { echo "mkdir -pv $LFS_TOOLS failed"; exit 1; }
[ "$(readlink /tools)" != $LFS_TOOLS ] && {
	echo "relink ..."
	sudo ln -svf $LFS_TOOLS / || \
		{ echo "ln -sv $LFS_TOOLS / failed"; exit 1; }
}

LFS_TOOLS=/tools

LFS_TESTS=$LFS/$LFS_ARCH/tests
LFS_TMP=$LFS/$LFS_ARCH/tmp
LFS_BUILD=$LFS_TMP/build
LFS_SRC=$LFS_TMP/src

set +h
umask 022
LC_ALL=POSIX

#[ -n "$(grep "$LFS/bin" <<<$PATH)" ] || PATH=$PATH:$LFS/bin
#[ -n "$(grep "^$LFS_TOOLS/bin" <<<$PATH)" ] || PATH=$LFS_TOOLS/bin:$PATH
PATH=/tools/bin:/bin:/usr/bin:$LFS/bin

vars="
LFS LFS_ARCH LFS_CPUNUM LFS_TGT LFS_MAKEFLAGS
LFS_SOURCES LFS_TOOLS LFS_TESTS LFS_BUILD LFS_SRC LC_ALL PATH"

export $vars

echo -e "\nLFS exports env values:"

for var in $vars
do
	printf "%-13s = '" $var
	eval echo -en "\$$var"
	echo "'"
done
echo ""

