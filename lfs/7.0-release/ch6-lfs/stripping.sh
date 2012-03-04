#!/bin/bash

echo "stripping ..."
/tools/bin/find /{,usr/}{bin,lib,sbin} -type f \
  -exec /tools/bin/strip --strip-debug '{}' ';'

#strip --strip-debug $LFS_TOOLS/lib/*
#strip --strip-unneeded $LFS_TOOLS/{,s}bin/*
#rm -fr $LFS_TOOLS/{,share}/{info,man}
echo "Here spaces are too enough, escaped it ..."
echo "$0 ok ......... ok"

