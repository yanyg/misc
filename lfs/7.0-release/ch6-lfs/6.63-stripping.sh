#!/bin/bash

echo "stripping ..."
/tools/bin/find /{,usr/}{bin,lib,sbin} -type f \
  -exec /tools/bin/strip --strip-debug '{}' ';'

echo "Here spaces are too enough, escaped it ..."
echo "$0 ok ......... ok"

