#!/bin/sh

#--omit-header
#--force-po

list="../ ../device_info ../disk_info ../event ../smart ../wis_mgr_src"
po_list=""

root=$(dirname $0)/esp/ui/src/cmd/
[ -e "$root" ] || mkdir -p $root

gen_po_dir()
{
	# longest common prefix ...
	local dir prefix file=$1

	dir=$(realpath $(dirname $file))
	prefix=$(echo -e "$(realpath $root)\n$dir" | \
		sed -e 'N;s/^\(.*\).*\n\1.*$/\1/')
	dir=esp/ui/src/cmd/${dir#$prefix}
	[ -e "$dir" ] || mkdir -p $dir
	echo "po_dir=${dir%/}"
}

gen_file()
{
	local file=$1 type l po opt

	type=$(file "$file")
	#opt="--force-po"
	opt="--omit-header"
	l=""

	case $type in
	*"shell script"*)
		l=Shell
		opt="$opt -kecho_nls -kecho_nls_exit"
		;;
	*python*)
		l=Python
		;;
	esac

	[ -z "$l" ] && \
	case $file in
	*.po|*.mo)
		l="";
		;;
	*.c)
		l=C
		;;
	*.cpp)
		l=C++
		;;
	*)
		echo "'$file' justice type failed ($type)" >&2
		l=""
		;;
	esac

	[ -z "$l" ] && return

	eval $(gen_po_dir $file)
	local dir=$(realpath $(dirname $file))
	local po=$po_dir/$(basename $file).po
	[ -e "$po" ] && opt="$opt -j"
	echo "xgettext -L $l $opt -o $po $file"
	xgettext -L $l $opt -o $po $file || \
		echo "fail: xgettext -L $l $opt -o $po $file" >&2
	[ -e "$po" ] || continue
	sed -i 's/charset=CHARSET/charset=UTF-8/' $po
	po_list="$po_list $po"
}

traver_dir()
{
	local files file dir=${1%/}
	files=$(ls "$dir")

	for file in $files
	do
		# recursive ...
		if [ -d "$dir/$file" ]; then
			#traver_dir "$dir/$file"
			:
		else
			gen_file "$dir/$file"
		fi
	done
}

for arg in $list
do
	if [ -d "$arg" ]; then
		traver_dir "$arg"
	else
		gen_file "$arg"
	fi
done

header=nls-header.$$
touch $header
xgettext --force-po -C -o $header.po $header
rm $header
sed -i 's/charset=CHARSET/charset=UTF-8/' $header.po

# discard repeat ...
po_list=$(echo $po_list | tr ' ' '\n' | sort | uniq | tr '\n' ' ')

echo msgfmt -o wis-nls.mo $po_list $header.po
msgfmt -o wis-nls.mo $po_list $header.po || echo "msgfmt failed" >&2
rm $header.po
