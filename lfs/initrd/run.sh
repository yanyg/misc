#!/bin/sh

[ ! -e "initrd.img" -o "$1" = "all" ] && {\
(
cd initrd
find . | cpio --quiet -H newc -o | gzip -9 -n > ../initrd.img
) || exit 1
}

qemu -initrd initrd.img -kernel bzImage -hda ../qemu/x86_64.img -append "root=/dev/sda rw $*"
