#!/bin/bash


echo "decompress source to $LFS_SRC/ch6"

works="
6.31-libtool-2.4.sh
6.32-gdbm-1.9.1.sh
6.33-inetutils-1.8.sh
6.34-perl-5.14.2.sh
6.35-autoconf-2.68.sh
6.36-automake-1.11.1.sh
6.37-diffutils-3.2.sh
6.38-gawk-4.0.0.sh
6.39-findutils-4.4.2.sh
6.40-flex-2.5.35.sh
6.41-gettext-0.18.1.1.sh
6.42-groff-1.21.sh
6.43-grub-1.99.sh
6.44-gzip-1.4.sh
6.45-iproute2-2.6.39.sh
6.46-kbd-1.15.2.sh
6.48-libpipeline-1.2.0.sh
6.49-make-3.82.sh
6.50-xz-5.0.3.sh
6.51-man-db-2.6.0.2.sh
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

dir=$(dirname $0)
PATH=$dir:$PATH

echo_exit()
{
	echo "$@"
	exit 1
}

echo "works="$works
for arg in $works
do
	$dir/$arg "$@" || echo_exit "$dir/$arg failed ..."
done

echo "work over success ..."
exit 0
