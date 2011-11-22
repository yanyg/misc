#!/bin/bash

self=$(basename $0)

usage()
{
	echo -e "\n  Usage:"
	echo -e "    $self <ip-suffix>"
	echo -e "\n  Examples:"
	echo -e "    $self 231"
	echo -e ""
	exit 1
}

[ $# -eq 1 ] || usage

echo_exit()
{
	echo $@
	exit 1
}

[ -d "$1" ] || sudo mkdir "$1"
dirs="bin dev etc home lib proc root sbin sys usr var dev/pts home/yanyg var/run"
for dir in $dirs
do
	[ -d "$1/$dir" ] || sudo mkdir -p "$1/$dir"
done

sudo ifconfig eth0:$1 down
sudo chroot $1 /etc/init.d/ssh stop
sudo umount $1/proc
sudo umount $1/dev/pts
sudo umount $1/sys
binds="bin sbin usr lib"
for bind in $binds
do
	sudo umount $1/$bind
done

echo "$self over ...."

