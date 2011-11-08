#!/bin/bash

mkdir -vp $LFS_TESTS
cd $LFS_TESTS
echo 'main() {}' > dummy.c
$LFS_TGT-gcc -B$LFS_TOOLS/lib dummy.c
readelf -l a.out | grep "interpreter:"
rm a.out dummy.c
