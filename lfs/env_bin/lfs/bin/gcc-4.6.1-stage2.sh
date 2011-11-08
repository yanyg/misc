#!/bin/bash

stage=stage2
pack=gcc-4.6.1.tar.bz2
patches=gcc-4.6.1-startfiles_fix-1.patch
# 1. check env, do downloads, unpack, etc.
# 2. export src, build
. $(dirname $0)/lfs-compile.sh

# saved gcc-envs
gcc_src=$src
gcc_build=$build

# add packs
packs="gmp-5.0.2.tar.bz2 mpfr-3.1.0.tar.bz2 mpc-0.9.tar.gz"
patches=""
for pack in $packs
do
	name=${pack%%-*}
	if [ ! -e "$gcc_src/$name" ]; then
		. $(dirname $0)/lfs-compile.sh
		echo "move $src to $gcc_src/$name"
		mv $src $gcc_src/$name
	fi
done

# restore
src=$gcc_src
build=$gcc_build

# manipulate code
if [ -e "$src/compile_patch_fixed" ]; then
	touch $src/compile_patch_fixed
	(
	# sub shell
	cd $src || echo_exit "into src directory '$src' failed ..."

	cp -v gcc/Makefile.in{,.orig}
	sed 's@\./fixinc\.sh@-c true@' gcc/Makefile.in.orig > gcc/Makefile.in

	cp -v gcc/Makefile.in{,.tmp}
	sed 's/^T_CFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in.tmp \
	  > gcc/Makefile.in
	
	for file in \
		$(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
	do
		cp -uv $file{,.orig}
		sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
			-e 's@/usr@/tools@g' $file.orig > $file
		echo '
#undef STANDARD_INCLUDE_DIR
#define STANDARD_INCLUDE_DIR 0
#define STANDARD_STARTFILE_PREFIX_1 ""
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
		touch $file.orig
	done

	case $(uname -m) in
		x86_64)
			for file in $(find gcc/config -name t-linux64) ; do \
				cp -v $file{,.orig}
				sed '/MULTILIB_OSDIRNAMES/d' $file.orig > $file
			done
			;;
	esac

#	cp -v gcc/Makefile.in{,.orig}
#	sed 's@\./fixinc\.sh@-c true@' gcc/Makefile.in.orig > gcc/Makefile.in

#	cp -v gcc/Makefile.in{,.tmp}
#	sed 's/^T_CFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in.tmp \
#	  > gcc/Makefile.in
	
#	for file in \
#		$(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
#	do
#		cp -uv $file{,.orig}
#		sed -e "s@/lib\(64\)\?\(32\)\?/ld@/$LFS_TOOLS&@g" \
#			-e "s@/usr@/$LFS_TOOLS@g" $file.orig > $file
#		echo '
#undef STANDARD_INCLUDE_DIR
#define STANDARD_INCLUDE_DIR 0
#define STANDARD_STARTFILE_PREFIX_1 ""
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
#		touch $file.orig
#	done

#	case $LFS_MACHINE in
#		x86_64)
#			for file in $(find gcc/config -name t-linux64)
#			do
#				cp -v $file{,.orig}
#				sed '/MULTILIB_OSDIRNAMES/d' $file.orig > $file
#			done
#			;;
#	esac
	)
fi

# prepare configure
mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# configure
if [ ! -e "Makefile" ]; then
	CC="$LFS_TGT-gcc -B$LFS_TOOLS/lib/" \
	AR=$LFS_TGT-ar \
	RANLIB=$LFS_TGT-ranlib \
	$src/configure \
		--prefix=$LFS_TOOLS \
		--with-local-prefix=$LFS_TOOLS --enable-clocale=gnu \
		--enable-shared --enable-threads=posix \
		--enable-__cxa_atexit --enable-languages=c,c++ \
		--disable-libstdcxx-pch --disable-multilib \
		--disable-bootstrap --disable-libgomp \
		--without-ppl --without-cloog \
		--with-mpfr-include=$src/mpfr/src \
		--with-mpfr-lib=$build/mpfr/src/.libs \
		|| echo_exit "configure $unpack failed"
fi

# make
make $LFS_MAKEFLAGS && \
make $LFS_MAKEFLAGS install && \
{
ln -sv gcc $LFS_TOOLS/bin/cc
true
} && \
echo "$0 ok ............... ok"
