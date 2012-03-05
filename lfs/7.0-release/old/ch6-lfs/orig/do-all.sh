#!/bin/bash


echo "decompress source to $LFS_SRC/ch6"

dir=$(dirname $0)
PATH=$dir:$PATH

works="
6.45-iproute2-2.6.39.sh
6.46-kbd-1.15.2.sh
6.48-libpipeline-1.2.0.sh
6.49-make-3.82.sh
6.51-xz-5.0.3.sh
6.52-man-db-2.6.0.2.sh
6.52-module-init-tools-3.16.sh
6.53-patch-2.6.1.sh
6.54-psmisc-22.14.sh
6.55-shadow-4.1.4.3.sh
6.56-sysklogd-1.5.sh
6.57-sysvinit-2.88dsf.sh
6.58-tar-1.26.sh
6.59-texinfo-4.13a.sh
6.60-udev-173.sh
6.61-vim-7.3.sh
"

echo "works="$works

for arg in $works
do
	$dir/$arg "$@"
done
