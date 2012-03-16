#!/bin/bash -ex
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
LFS_TGT=$LFS_ARCH-yyg-linux-gnu
LFS_MAKEFLAGS="-j$LFS_CPUNUM"

LFS_SOURCES=$LFS/sources
LFS_TOOLS=$LFS/$LFS_ARCH/tools

echo_return()
{
	echo "ERR: $@"
	return 1
}

LFS_QEMU=$LFS/qemu
LFS_QEMU_FILE=$(realpath $LFS_QEMU/$LFS_ARCH.img)
LFS_QEMU_LOOP=$(echo $(sudo losetup -a | grep $LFS_QEMU_FILE) | cut -d: -f1)
[ -z "$LFS_QEMU_LOOP" ] && \
	LFS_QEMU_LOOP=$(sudo losetup --show -f $LFS_QEMU_FILE)
[ -z "$LFS_QEMU_LOOP" ] && \
	{ echo_return "Try losetup $LFS_QEMU_FILE failed ..." || return 1; }
	echo $LFS_QEMU_FILE
[ -z "$(mount | grep $LFS/$LFS_ARCH )" ] && {
sudo mount -t ext3 $LFS_QEMU_LOOP $LFS/$LFS_ARCH || \
	{ echo_return "Please format $LFS_QEMU_LOOP as ext3 first ?" || \
		return 1; }
#sudo chown -R root:root $LFS_TOOLS || \
#	{ echo_return "chown failed" || return 1; }
rm -fr $LFS/$LFS_ARCH/lost+found
}

mkdir -pv $LFS_TOOLS || { \
	echo_return "mkdir -pv $LFS_TOOLS failed" || return 1; }
[ "$(readlink /tools)" != $LFS_TOOLS ] && {
	echo "relink ..."
	sudo ln -svf $LFS_TOOLS / || \
		{ echo_return "ln -sv $LFS_TOOLS / failed" || return 1; }
}

LFS_TOOLS=/tools

LFS_TESTS=$LFS/$LFS_ARCH/tests
LFS_TMP=$LFS/$LFS_ARCH/haywire
LFS_BUILD=$LFS_TMP/build
LFS_SRC=$LFS_TMP/src

set +h
umask 022
LC_ALL=POSIX

#[ -n "$(grep "$LFS/bin" <<<$PATH)" ] || PATH=$PATH:$LFS/bin
#[ -n "$(grep "^$LFS_TOOLS/bin" <<<$PATH)" ] || PATH=$LFS_TOOLS/bin:$PATH
PATH=/tools/bin:/bin:/usr/bin:$LFS/bin

vars="
LFS LFS_ARCH LFS_CPUNUM LFS_TGT LFS_MAKEFLAGS LFS_QEMU
LFS_SOURCES LFS_TOOLS LFS_TESTS LFS_BUILD LFS_SRC LC_ALL PATH"

export $vars

echo -e "\nLFS exports env values:"

for var in $vars
do
	printf "\t%-13s = '%s'\n" $var $(eval echo \$$var)
done
echo ""

