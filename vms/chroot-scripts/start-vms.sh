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

[ -e "$1/etc/ssh/sshd_config" ] || {
	sudo cp -a /etc $1/
	sudo vi $1/etc/ssh/sshd_config
}

binds="bin sbin usr lib"
for bind in $binds
do
	sudo mount --bind /$bind $1/$bind
done

(
	cd $1/dev || echo_exit "into $1/dev failed"

	[ -e "console" ] || sudo mknod console c 5 1
	[ -e "null" ] || sudo mknod -m666 null c 1 3
	[ -e "ptmx" ] || sudo mknod -m666 ptmx c 5 2
	[ -e "tty" ] || sudo mknod -m666 tty c 5 0
	[ -e "urandom" ] || sudo mknod -m666 urandom c 1 9

) || exit 1

sudo mount -t proc -o nodev,noexec,nosuid none $1/proc
sudo mount -t devpts none $1/dev/pts
sudo mount -t sysfs -o nodev,noexec,nosuid none $1/sys


sudo ifconfig eth0:$1 192.168.100.$1/24
sudo chroot $1 /etc/init.d/ssh start

echo "$self over ...."

