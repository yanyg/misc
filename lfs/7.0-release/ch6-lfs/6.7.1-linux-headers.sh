#!/bin/bash -x

pack=linux-3.1

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

cd $src || echo_exit "into $src failed"
make mrproper || echo_exit "make mrproper failed"
make headers_check || echo_exit "make headers check failed"
make INSTALL_HDR_PATH=$build headers_install || \
	echo_exit "make headers_install failed"
find $build/include \( -name .install -o -name ..install.cmd \) -delete

cp -rv $build/include/* /usr/include || \
	echo_exit "cp -rv $build/include/* /usr/include failed"
echo "$0 ok ............... ok"
