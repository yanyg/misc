#!/bin/sh
#
# Wisdata All Copyright Reserved
# Wisdata library of sh language
# 2011-09-05

# Function commonalities
#
# Exit status
#	0		--	success
#	!0		--	fail (!0 means non-zero)
#
# Output descriptor (default)
#	success	--	stdout(1)
#	fail	--	stderr(2)
# The stdout and stderr can be overwritten by arguments.
#
: ${RTN_SUCC:=0}
: ${RTN_FAIL:=1}
: ${RTN_ERROR:=1}

# global controller-parameters
: ${libwis_stdin:=0}
: ${libwis_stdout:=1}
: ${libwis_stderr:=2}
: ${libwis_debug:="off"}

# fd for debug: fds 20~21 are used
# busybox need fd < 10
: ${fd_null:=8}
: ${fd_debug:=9}
: ${FD_NULL:=/dev/null}
: ${FD_DEBUG:=/dev/null}

# libwis_isdigit
#	check a string is a integer or not
# Usage
#	libwis_isdigit "12598"		# return 0
#	libwis_isdigit "not"		# return 1
#	libwis_isdigit ""			# return 1
#	libwis_isdigit				# return 1
libwis_isdigit()
{
	[ -z "$1" -o -z "${1##*[!0-9]*}" ] && return $RTN_FAIL
	return $RTN_SUCC
}

libwis_isvarname()
{
	[ -z "$1" -o -z "${1##*[!A-Za-z0-9_]*}" ] && return $RTN_FAIL
	return $RTN_SUCC
}

libwis_isdeclared()
{
	# valid variable name, non-empty variable or empty variable
	libwis_isvarname "$1" &&\
		[ -n "$(eval echo \"\$$1\")" -o -z "$(eval echo \${$1-declared})" ] &&\
		return $RTN_SUCC

	return $RTN_FAIL
}

# toolbox
libwis_print()
{
	echo "$@" >& ${libwis_stdout}
}

: ${libwis_warn_prefix=$(basename $0)}
libwis_warn()
{
	local warn_prefix

	if [ -n "$FUNCNAME" ]; then
		warn_prefix="$FUNCNAME"
	elif [ -n "$func" ]; then
		warn_prefix="$func"
	else
		warn_prefix="$libwis_warn_prefix"	# others ...
	fi

	[ -n "$warn_prefix" ] && echo -n "$warn_prefix: " >& ${libwis_stderr}
	echo "$@" >& ${libwis_stderr}
}

libwis_debug()
{
	: ${libwis_debug_switch:=off}
	[ "$libwis_debug_switch" = "on" ] && libwis_warn "$@"
}

libwis_exit()
{
	local status="$1"

	if libwis_isdigit "$status"; then
		shift
	else
		status=0
	fi

	if [ "$#" -gt "0" ]; then
		if [ "$status" -eq "0" ]; then
			libwis_print "$@"
		else
			libwis_warn "$@"
		fi
	fi

	exit $status
}

# usage: "libwis_string_replace"
libwis_string_replace()
{
	local args original result
	local cmd="$(which sed)"
	local func="libwis_string_replace"

	local string="$1"; shift

	for args in "$@"
	do
		original=${args%%,*}
		if [ -n "${args##*,*}" -o  -z "$original" ]; then
			libwis_warn "$func: pattern unrecongized '$args'. You should separate pattern by comma (original,result) and original cannot be empty"
			continue
		fi
		result=${args#*,}

		if [ -n "$cmd" ]; then
			string="$(echo "$string" | sed -e "s/$original/$result/g")"
		else
			return 1
		fi
	done

	echo "$string"
}


# libwis_generate_raid_info
# sage:
#	libwis_generate_raid_info <raid-dev-name> [info-prefix]
#
# arguments
#	<raid-dev-name>		--	valid raid device name,	required
#	[info-prefix]		--	prefix of export info, optional
#							start with [A-Za-z] or underscore.
#
libwis_generate_raid_info()
{
	local dev="$1" prefix="$2"

	# check dev && prefix
	if [ ! -b "$dev" ]; then
		libwis_warn "$dev is not a block device"
		return $RTN_FAIL
	fi

	: ${prefix:=raid}
	if ! libwis_isvarname "$prefix"; then
		libwis_warn "$prefix is not a valid variable name"
		return $RTN_FAIL
	fi

	local report info

	if ! info=$(mdadm --detail $dev 2>/dev/null); then
		libwis_warn "mdadm --detail $dev failed"
		return $RTN_FAIL
	fi

	# internal functions
	# and it will be unset before return
	# so don't try to use its other where

	# usage: parse_patns "name1,patn1" ["name2,patn2"] [...]
	parse_patns()
	{
		local name patn value
		for args in "$@"
		do
			name=${args%%,*}
			patn=${args#*,}
			value=$(echo "$info" | grep "^ *\<$patn : " | awk '{FS=" *[A-Za-z0-9]* : "; print $2}')
			if [ -n "$value" ]; then
				report="$report ${prefix}_${name}='$value'"
			else
				libwis_warn "parse '$name,$patn' from $dev info failed"
			fi
		done
		report="${report# }"
	}
	# usage: parse_disks ["disks"]
	parse_disks()
	{
		local line disk disks name="$1"

		# check and reset name
		: ${name:=disks}

		{
			# ignored lines ...
			while read line
			do
				[ -n "$(echo "$line" | grep "Number *Major *Minor *RaidDevice *State")" ] && break
			done

			# parse
			while read line
			do
				[ -z "$line" ] && continue
				if [ -n "$(echo "$line" | grep "\<faulty spare\>" )" ]; then
					libwis_warn "parse disks $line is a faulty spare"
					continue
				fi
				if [ -n "$(echo "$line" | grep "\<removed\>" )" ]; then
					libwis_warn "parse disks $line is a removed"
					continue
				fi
				disk="${line##* }"
				if [ -n "$disk" -a -b "$disk" ]; then
					disks="$disks $disk"
				else
					libwis_warn "parse disks $line from $dev failed"
				fi
			done

			disks="${disks# }"

			report="$report ${prefix}_${name}='$disks'"
		} << EOF
$(echo "$info")
EOF
	}

	# call internal routines to do work
	parse_patns "array_size,Array Size" "level,Raid Level" "devices,Raid Devices" "working_devices,Working Devices" "state,State" "uuid,UUID"
	parse_disks

	unset -f parse_patns parse_disks

	echo "$report"
}

# usage:
#	libwis_getopt "prefix" "long-opt-string" "short-opt-string" "opt1" ["opt2" ...]
#	--> opt-string is separated by comma(,)
libwis_getopt()
{
	local prefix="$1" lopt="$2" sopt="$3"
	local func="libwis_getopt"

	if [ "$#" -lt "3" -o -z "${lopt}${sopt}" ]; then
		libwis_warn "$func: arguments error"
		return $RTN_FAIL
	fi
	shift; shift; shift

	if [ -n "$prefix" ] && ! libwis_isvarname "$prefix"; then
		libwis_warn "$func: $prefix is not a valid variable name"
		return $RTN_FAIL
	fi
	[ -n "${prefix%%*_}" ] && prefix="${prefix}_"

	# internal function
	# usage : parse_long_opt <"opt-name">
	parse_long_opt()
	{
		local name="${1%%=*}" value="${1#*=}"
		local real_name="${prefix}$(libwis_string_replace "$name" "-,_")"

		[ "$name" = "$value" ] && value=""
		report=""
		for args in $(IFS=","; echo $lopt)
		do
			case "$args" in
				"$name")
				[ -n "$value" ] && libwis_warn "$func: '--$name' doesn't require a value"
				report="$real_name='$value'"
				;;
				"$name:")
				if [ -n "$value" ]; then
					report="$real_name='$value'"
				elif [ -n "$2" -a -n "${2##-*}" ]; then
					report="$real_name='$2'"
					is_shift="yes"
				else
					libwis_warn "$func: argument '--$name' requires a value"
					return $RTN_FAIL
				fi
				;;
				"$name::")
				if [ -n "$value" ]; then
					report="$real_name='$value'"
				elif [ -n "$2" -a -n "${2##-*}" ]; then
					report="$real_name='$2'"
					is_shift="yes"
				else
					report="$real_name=''"
				fi
				;;
				"*")
				;;
			esac

			[ -n "$report" ] && break
		done

		if [ -z "$report" ]; then
			libwis_warn "$func: parse $1 failed"
			return $RTN_FAIL
		else
			return $RTN_SUCC
		fi
	}

	parse_short_opt()
	{
		local opt="$(expr substr "$1" 1 1)" real_name="${prefix}$(libwis_string_replace "$1" "-,_")"

		if [ -z "${sopt##*$opt:*}" ]; then
			report="$real_name"
		fi
	}

	local args report reports is_shift

	while [ "$#" -ne "0" ]
	do
		args="$1"; shift
		[ -z "$args" ] && continue
		[ -n "${args##-*}" ] && { libwis_warn "$func: invalid argument '$args'"; continue; }
		[ -z "${args##*-}" ] && break	# '--' means break parse

		is_shift="" report=""
		# parse, the result will be saved to variable 'report'
		if [ -z "${args##--*}" ]; then	# long-opt
			parse_long_opt "${args##--}" "$1"	# S2 may be needed
		else
			# short-opt
			parse_short_opt "${args##-}" "$1"
		fi

		[ "$?" -eq "0" ] && reports="$reports $report"
		[ "$is_shift" = "yes"  ] && shift
	done

	reports="${reports# }"

	echo "$reports"
}

# open debug and null
fd_wis_lib()
{
	local redir

	# fd_null:
	redir=">"
	libwis_isdigit "$FD_NULL" && redir=">&"
	eval exec "$fd_null$redir$FD_NULL"

	# fd_debug
	redir=">"
	libwis_isdigit "$FD_DEBUG" && redir=">&"
	eval exec "$fd_debug$redir$FD_DEBUG"
}

fd_wis_lib_embedded()
{
#	libwis_isdigit "$FD_NULL" && {
#		echo "FD_NULL=$FD_NULL is a digit, busybox cannot support, Please replaced with filename(include one non-digit character at least)"
#		exit 1
#	}
#	libwis_isdigit "$FD_DEBUG" && {
#		echo "FD_DEBUG=$FD_DEBUG is a digit, busybox cannot support, Please replaced with filename(include one non-digit character at least)"
#		exit 1
#	}

	# busybox fd cannot bigger than 9 ...
	local redir

	redir=">"; libwis_isdigit "$FD_NULL" && redir=">&"
	eval exec "$fd_null$redir$FD_NULL"

	redir=">"; libwis_isdigit "$FD_DEBUG" && redir=">&"
	eval exec "$fd_debug$redir$FD_DEBUG"
}
# call func
fd_wis_lib_embedded

# debug func:
wis_debug()
{
	echo $@ >& $fd_debug
}
