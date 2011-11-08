#!/bin/bash

echo "compile chapter 5 all ..."

packs=\
"
binutils-2.21.1-stage1.sh \
gcc-4.6.1-stage1.sh \
linux-headers.sh \
glibc-2.14.1.sh \
binutils-2.21.1-stage2.sh \
gcc-4.6.1-stage2.sh \
tcl8.5.10.sh \
expect5.45.sh \
dejagnu-1.5.sh \
check-0.9.8.sh \
ncurses-5.9.sh \
bash-4.2.sh \
bzip2-1.0.6.sh \
coreutils-8.14.sh \
diffutils-3.2.sh \
file-5.09.sh \
findutils-4.4.2.sh \
gawk-4.0.0.sh \
gettext-0.18.1.1.sh \
grep-2.9.sh \
gzip-1.4.sh \
m4-1.4.16.sh \
make-3.82.sh \
patch-2.6.1.sh \
perl-5.14.2.sh \
sed-4.2.1.sh \
tar-1.26.sh \
texinfo-4.13a.sh \
xz-5.0.3.sh \
stripping.sh \
changing-owner.sh\
"

do=yes
if [ -n "$1" ]; then
	do=no
fi

for pack in $packs
do
	if [ "$do" = "no" ]; then
		if [ "$pack" = "$1" ]; then
			do=yes
		else
			continue
		fi
	fi
	echo "install $pack now ..."
	$pack || { echo "$pack install failed ..."; exit 1; }
done

echo "do_all.sh success over ..."
