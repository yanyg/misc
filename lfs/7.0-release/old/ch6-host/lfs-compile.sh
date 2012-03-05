#!/bin/bash -x

echo_exit()
{
	[ $# -ne 0 ] && echo "LFS Error: $@"
	exit 1
}

stage=lfs-src

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

file=$LFS_SOURCES/$pack

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
[ ! -d "$unpack" ] && unpack=${unpack%/*}
[ -z "${unpack%%*/m4}" ] && unpack=${unpack%/*}
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
			patch -Np1 -i $LFS_SOURCES/$patch || echo_exit "patches '$patch' to pack '$pack' failed"
		done
		) || exit 1
	fi
fi

echo "$0: unpack $pack into '$src' successfully ..."
echo "!!!!!!!!!! $src"
