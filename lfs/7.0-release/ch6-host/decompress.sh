#!/bin/bash -x

packs="
autoconf-2.68.tar.bz2
automake-1.11.1.tar.bz2
bash-4.2-fixes-3.patch
bash-4.2.tar.gz
binutils-2.21.1a.tar.bz2
bison-2.5.tar.bz2
bzip2-1.0.6-install_docs-1.patch
bzip2-1.0.6.tar.gz
check-0.9.8.tar.gz
coreutils-8.14-i18n-1.patch
coreutils-8.14-uname-1.patch
coreutils-8.14.tar.xz
dejagnu-1.5.tar.gz
diffutils-3.2.tar.gz
e2fsprogs-1.41.14.tar.gz
expect5.45.tar.gz
file-5.09.tar.gz
findutils-4.4.2.tar.gz
flex-2.5.35-gcc44-1.patch
flex-2.5.35.tar.bz2
gawk-4.0.0.tar.bz2
gcc-4.6.1-cross_compile-1.patch
gcc-4.6.1-locale-1.patch
gcc-4.6.1-startfiles_fix-1.patch
gcc-4.6.1.tar.bz2
gdbm-1.9.1.tar.gz
gettext-0.18.1.1.tar.gz
glibc-2.14.1-cpuid-1.patch
glibc-2.14.1-fixes-1.patch
glibc-2.14.1-gcc_fix-1.patch
glibc-2.14.1.tar.bz2
gmp-5.0.2.tar.bz2
grep-2.9.tar.gz
groff-1.21.tar.gz
grub-1.99.tar.gz
gzip-1.4.tar.gz
iana-etc-2.30.tar.bz2
inetutils-1.8.tar.gz
iproute2-2.6.39.tar.gz
kbd-1.15.2-backspace-1.patch
kbd-1.15.2.tar.gz
less-444.tar.gz
lfs-bootscripts-20111017.tar.bz2
libpipeline-1.2.0.tar.gz
libtool-2.4.tar.gz
linux-3.1.tar.bz2
m4-1.4.16.tar.bz2
make-3.82.tar.bz2
man-db-2.6.0.2.tar.gz
man-pages-3.35.tar.gz
module-init-tools-3.16-man_pages-1.patch
module-init-tools-3.16.tar.bz2
mpc-0.9.tar.gz
mpfr-3.1.0.tar.bz2
ncurses-5.9.tar.gz
patch-2.6.1-test_fix-1.patch
patch-2.6.1.tar.bz2
perl-5.14.2-libc-1.patch
perl-5.14.2.tar.bz2
procps-3.2.8-fix_HZ_errors-1.patch
procps-3.2.8-watch_unicode-1.patch
procps-3.2.8.tar.gz
psmisc-22.14.tar.gz
readline-6.2-fixes-1.patch
readline-6.2.tar.gz
sed-4.2.1.tar.bz2
shadow-4.1.4.3.tar.bz2
sysklogd-1.5.tar.gz
sysvinit-2.88dsf.tar.bz2
tar-1.26.tar.bz2
tcl8.5.10-src.tar.gz
texinfo-4.13a.tar.gz
udev-173-testfiles.tar.bz2
udev-173.tar.bz2
udev-config-20100128.tar.bz2
util-linux-2.20.tar.bz2
vim-7.3.tar.bz2
xz-5.0.3.tar.bz2
zlib-1.2.5.tar.bz2
"

for arg in $packs
do
	[ -z "${arg%%*patch}" ] && {
		cp -fv $LFS_SOURCES/$arg $LFS_SRC/lfs-src/
		continue
	}
	pack=$arg
	pack_checked=yes
	. $(dirname $0)/lfs-compile.sh
done

pack=udev-173.tar.bz2
pack_checked=yes
set -- all
. $(dirname $0)/lfs-compile.sh

echo "$0 ok ............... ok"
