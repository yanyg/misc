#!/bin/bash

echo_exit()
{
	[ $# -ne 0 ] && echo "LFS Error: $@"
	exit 1
}

[ -n "$LFS" ] || echo_exit "Please source env_set.sh first"
[ -e "$LFS/tools" ] || mkdir -pv $LFS/tools
[ -e "/tools" ] || ln -sv $LFS/tools /

[ -n "$pack" ] || echo_exit "Please specify the pack(compressed code pack)"
[ -n "$stage" ] || stage="."

[ "$pack" = "none" ] && return

# check pack now
if [ "$pack_checked" != "yes" ]; then
	pack_checked=yes
	prefix_file=$(basename $0)
	prefix_file=${prefix_file%%[-.]*}
	prefix_pack=${pack%%[.-]*}
	[[ "$prefix_file" = "$prefix_pack" ]] || echo_exit "prefix_file=$prefix_file, prefix_pack=$prefix_pack, check first ..."
fi

lfs_download()
{
	local dlf all_dlf="$pack $patches"
	for dlf in $all_dlf
	do
		if [ ! -e "$LFS_DOWNLOADS/$dlf" ]; then
			url=$(grep "$dlf" <<<"$(cat <<EOF
http://ftp.gnu.org/gnu/autoconf/autoconf-2.68.tar.bz2
http://ftp.gnu.org/gnu/automake/automake-1.11.1.tar.bz2
http://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz
http://ftp.gnu.org/gnu/binutils/binutils-2.21.1a.tar.bz2
http://ftp.gnu.org/gnu/bison/bison-2.5.tar.bz2
http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
http://sourceforge.net/projects/check/files/check/0.9.8/check-0.9.8.tar.gz
http://ftp.gnu.org/gnu/coreutils/coreutils-8.14.tar.xz
http://ftp.gnu.org/gnu/dejagnu/dejagnu-1.5.tar.gz
http://ftp.gnu.org/gnu/diffutils/diffutils-3.2.tar.gz
http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.41.14.tar.gz
http://prdownloads.sourceforge.net/expect/expect5.45.tar.gz
ftp://ftp.astron.com/pub/file/file-5.09.tar.gz
http://ftp.gnu.org/gnu/findutils/findutils-4.4.2.tar.gz
http://prdownloads.sourceforge.net/flex/flex-2.5.35.tar.bz2
http://ftp.gnu.org/gnu/gawk/gawk-4.0.0.tar.bz2
http://ftp.gnu.org/gnu/gcc/gcc-4.6.1/gcc-4.6.1.tar.bz2
http://ftp.gnu.org/gnu/gdbm/gdbm-1.9.1.tar.gz
http://ftp.gnu.org/gnu/gettext/gettext-0.18.1.1.tar.gz
http://ftp.gnu.org/gnu/glibc/glibc-2.14.1.tar.bz2
http://ftp.gnu.org/gnu/gmp/gmp-5.0.2.tar.bz2
http://ftp.gnu.org/gnu/grep/grep-2.9.tar.gz
http://ftp.gnu.org/gnu/groff/groff-1.21.tar.gz
http://ftp.gnu.org/gnu/grub/grub-1.99.tar.gz
http://ftp.gnu.org/gnu/gzip/gzip-1.4.tar.gz
http://anduin.linuxfromscratch.org/sources/LFS/lfs-packages/conglomeration//iana-etc/iana-etc-2.30.tar.bz2
http://ftp.gnu.org/gnu/inetutils/inetutils-1.8.tar.gz
http://devresources.linuxfoundation.org/dev/iproute2/download/iproute2-2.6.39.tar.gz
http://anduin.linuxfromscratch.org/sources/LFS/lfs-packages/conglomeration/kbd/kbd-1.15.2.tar.gz
http://www.greenwoodsoftware.com/less/less-444.tar.gz
http://www.linuxfromscratch.org/lfs/downloads/7.0-rc2/lfs-bootscripts-20111008.tar.bz2
http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.2.0.tar.gz
http://ftp.gnu.org/gnu/libtool/libtool-2.4.tar.gz
http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.0.4.tar.gz
http://ftp.gnu.org/gnu/m4/m4-1.4.16.tar.bz2
http://ftp.gnu.org/gnu/make/make-3.82.tar.bz2
http://download.savannah.gnu.org/releases/man-db/man-db-2.6.0.2.tar.gz
http://man7.org/linux/man-pages/download/man-pages-3.35.tar.gz
http://anduin.linuxfromscratch.org/sources/LFS/lfs-packages/conglomeration/module-init-tools/module-init-tools-3.16.tar.bz2
http://www.multiprecision.org/mpc/download/mpc-0.9.tar.gz
http://www.mpfr.org/mpfr-3.1.0/mpfr-3.1.0.tar.bz2
ftp://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz
http://ftp.gnu.org/gnu/patch/patch-2.6.1.tar.bz2
http://www.cpan.org/src/5.0/perl-5.14.2.tar.bz2
http://procps.sourceforge.net/procps-3.2.8.tar.gz
http://prdownloads.sourceforge.net/psmisc/psmisc-22.14.tar.gz
http://ftp.gnu.org/gnu/readline/readline-6.2.tar.gz
http://ftp.gnu.org/gnu/sed/sed-4.2.1.tar.bz2
http://pkg-shadow.alioth.debian.org/releases/shadow-4.1.4.3.tar.bz2
http://www.infodrom.org/projects/sysklogd/download/sysklogd-1.5.tar.gz
http://download.savannah.gnu.org/releases/sysvinit/sysvinit-2.88dsf.tar.bz2
http://ftp.gnu.org/gnu/tar/tar-1.26.tar.bz2
http://prdownloads.sourceforge.net/tcl/tcl8.5.10-src.tar.gz
http://ftp.gnu.org/gnu/texinfo/texinfo-4.13a.tar.gz
http://anduin.linuxfromscratch.org/sources/LFS/lfs-packages/conglomeration/udev/udev-173.tar.bz2
http://anduin.linuxfromscratch.org/sources/other/udev-173-testfiles.tar.bz2
http://www.linuxfromscratch.org/lfs/downloads/7.0-rc2/udev-config-20100128.tar.bz2
http://anduin.linuxfromscratch.org/sources/LFS/lfs-packages/conglomeration/util-linux/util-linux-2.20.tar.bz2
ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2
http://tukaani.org/xz/xz-5.0.3.tar.bz2
http://www.zlib.net/zlib-1.2.5.tar.bz2
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/bash-4.2-fixes-3.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/bzip2-1.0.6-install_docs-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/coreutils-8.14-i18n-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/coreutils-8.14-uname-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/flex-2.5.35-gcc44-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/gcc-4.6.1-cross_compile-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/gcc-4.6.1-startfiles_fix-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/glibc-2.14.1-fixes-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/glibc-2.14.1-gcc_fix-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/glibc-2.14.1-cpuid-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/gcc-4.6.1-locale-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/kbd-1.15.2-backspace-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/module-init-tools-3.16-man_pages-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/patch-2.6.1-test_fix-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/perl-5.14.2-libc-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/procps-3.2.8-fix_HZ_errors-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/procps-3.2.8-watch_unicode-1.patch
http://www.linuxfromscratch.org/patches/lfs/7.0-rc2/readline-6.2-fixes-1.patch
EOF
			)")
			[ -n "$url" ] || echo_exit "parse '$dlf' url failed"
			wget $url --directory-prefix=$LFS_DOWNLOADS || echo_exit "download $pack from '$url' failed"
		fi
	done
}

# download ...
lfs_download

# test pack type
case "$pack" in
	*".tar.bz2"|*".tbz2")
		td=j
		;;
	*".tar.gz"|*".tgz")
		td=z
		;;
	*".tar.xz"|*".txz")
		td=J
		;;
	*".tar")
		td=""
		;;
	*)
		echo_exit "pack '$pack' format cannot recognized, valid pack is tar.bz2|tar.gz|tar.xz|tbz2|tgz|txz"
		;;
esac

file=$LFS_DOWNLOADS/$pack

# check unpack directory ...
check_unpack_dir_quick()
{
	tar tf$td "$file" 2>/dev/null | {
		read; echo $REPLY;
		local pid=$(ps aux | grep "[0-5][0-9] tar tf$td $file" | awk '{print $2}')
		[ -n "$pid" ] && kill -9 $pid 2>/dev/null
	}
}
echo "check top-directory of '$pack', please wait ..."
unpack=$(check_unpack_dir_quick)
unpack=${unpack%/}
[ -n "$unpack" ] || echo_exit "query $pack's directory is empty, check '$file' first"
src=$LFS_SRC/$stage/$unpack
build=$LFS_BUILD/$stage/$unpack

mkdir -p {$LFS_SRC,$LFS_BUILD}/$stage || echo_exit "create source/build directory failed: " {$LFS_SRC,$LFS_BUILD}/$stage
[ "$1" = "all" ] && rm -fr $src
if [ ! -e "$src" ]; then
	# test pack type
	tar xfv$td $file --directory $LFS_SRC/$stage || echo_exit "unpack '$file' failed"

	if [ -n "$patches" ]; then
		# sub-shell
		(
		cd $src || echo_exit "into directory $src failed"
		for patch in $patches
		do
			echo "patch '$patch' now ..."
			patch -Np1 -i $LFS_DOWNLOADS/$patch || echo_exit "patches '$patch' to pack '$pack' failed"
		done
		) || exit 1
	fi
fi

echo "$0: unpack $pack into '$src' successfully ..."
