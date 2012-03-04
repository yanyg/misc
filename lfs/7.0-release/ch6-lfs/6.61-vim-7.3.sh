#!/bin/bash -x

pack=vim73

. $(dirname $0)/6-lfs-compile.sh

mkdir -pv $build || echo_exit "create build directory failed: build='$build'"
[ "$1" = "all" ] && rm -fr $build/*
cd $build || echo_exit "into build directory failed: build='$build'"

# fix code
if [ ! -e "$src/fix-touch" ]; then
	(
	cd $src
	echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
	)
	touch $src/fix-touch
fi

cd $src
# configure
$src/configure \
	--prefix=/usr \
	--enable-multibyte \
	|| echo_exit "configure $unpack failed"

make && \
true && \
make install || echo_exit "make failed"

ln -sv vim /usr/bin/vi
for L in /usr/share/man/{,*/}man1/vim.1; do
	ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim73/doc /usr/share/doc/vim-7.3

cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc
set nocompatible
set backspace=2
syntax on
if (&term == "iterm") || (&term == "putty")
	set background=dark
endif
" End /etc/vimrc
EOF

vim -c ':options'

echo "$0 ok ............... ok"
