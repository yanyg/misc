#!/bin/bash -x

echo_exit()
{
	[ $# -ne 0 ] && echo "LFS Error: $@"
	exit 1
}

stage=lfs-src

[ -n "$pack" ] || echo_exit "Please specify the pack(compressed code pack)"
[ -n "$stage" ] || stage="."

[ "$pack" = "none" ] && return

op_root=/haywire
src=$op_root/src/$stage/$pack
build=$op_root/build/ch6/$pack
