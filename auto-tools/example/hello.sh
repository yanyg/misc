#!/bin/sh

echo "create directory ..."
echo_exit()
{
	echo "ERROR: $@"
	exit 1
}

# 1.
mkdir hello && cd hello || echo_exit "mkdir hello or cd hello failed"
cat > hello.c <<EOF || echo_exit "generates hello.c failed"
#include <stdio.h>
int main()
{
    printf("hello auto-tools!\n");
    return 0;
}
EOF

# 2.
cat > Makefile.am << EOF || echo_exit "generates Makefile.am failed"
bin_PROGRAMS = hello
hello_SOURCES = hello.c
EOF

# 3.
cat > configure.ac << EOF || echo_exit "generates configure.ac failed"
#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.67])
AC_INIT([hello], [1.0], [yygcode@gmail.com])
AM_INIT_AUTOMAKE([-Wall -Werror foreign])
AC_CONFIG_SRCDIR([hello.c])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CC

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
EOF

# 4.
autoreconf --install || echo_exit "autoreconf --install failed"

# 5.
./configure && make || echo_exit "configure or make failed"

# 6.
make dist && make distcheck || echo_exit "make dist && make distcheck failed"

echo "All Do Over Success"
