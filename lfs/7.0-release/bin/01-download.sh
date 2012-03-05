#!/bin/bash

source=sources
[ -d "$source" ] || mkdir -p $source
while read line
do
	name=${line##*/}
	[ -e "$source/$name" ] && {
		echo "exists , continue ..."
		continue
	}

	echo "download $line"
	wget -P $source/ $line
done <<EOF
$(cat resource/wget-list)
EOF
