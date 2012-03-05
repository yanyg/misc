#!/bin/bash -x

pack=lana-etc-2.30.sh

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	touch $src/fix-touch
fi

cd $src || echo_exit "into $src failed"
make && \
make install || echo_exit "make failed"

echo "$0 ok ............... ok"


