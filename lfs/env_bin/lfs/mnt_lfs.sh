#!/bin/bash

echo "Mount lfs partition ..."

if [ -z "${0##*/*}" ]; then
	cur_dir=$(dirname $0)
else
	cur_dir=.
fi

if [ -z "$LFS" ]; then
	. $cur_dir/env_set.sh
fi

sudo mkdir -pv $LFS
sudo mount -v -t ext3 /dev/sda2 $LFS
