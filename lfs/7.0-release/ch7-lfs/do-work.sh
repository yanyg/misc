#!/bin/bash

echo_exit()
{
	echo "$@"
	exit 1
}

echo "network device for udev' rules ..."
for NIC in /sys/class/net/* ; do
	INTERFACE=${NIC##*/} udevadm test --action=add $NIC
done

echo "network ip ..."
cat > /etc/sysconfig/ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=192.168.100.199
GATEWAY=192.168.100.1
PREFIX=24
BROADCAST=192.168.100.255
EOF

echo "/etc/resolv.conf ..."
cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf
domain yyg
nameserver 202.106.46.151
nameserver 202.106.0.20
# End /etc/resolv.conf
EOF

echo "/etc/hosts ..."
cat > /etc/hosts << "EOF"
# Begin /etc/hosts (network card version)
127.0.0.1 localhost
# End /etc/hosts (network card version)
EOF

echo "install lfs-bootscripts ..."
(
cd /haywire/src/lfs-src/lfs-bootscripts-20111017 &&
make install || echo_exit "install lfs-bootscripts-20111017 failed"
) || exit 1

echo "config sysvinit ..."
cat > /etc/inittab << "EOF"
# Begin /etc/inittab
id:3:initdefault:
si::sysinit:/etc/rc.d/init.d/rc S
l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6
ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now
su:S016:once:/sbin/sulogin
1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600
# End /etc/inittab
EOF

echo "HOSTNAME=yyg" > /etc/sysconfig/network
cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock
UTC=1
# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=
# End /etc/sysconfig/clock
EOF

cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>
# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off
# Enable 8bit input
set meta-flag On
set input-meta On
# Turns off 8th bit stripping
set convert-meta Off
# Keep the 8th bit for display
set output-meta On
# none, visible or audible
set bell-style none
# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word
# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert
# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line
# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line
# End /etc/inputrc
EOF

cat > /etc/fstab << "EOF"
# Begin /etc/fstab
# file system  mount-point type   options        dump fsck
#                                                     order
UUID=dc7bf564-df52-45f6-b083-b44655d82f1b /   ext3   errors=remount-ro	0    1
proc           /proc       proc   defaults       0    0
sysfs          /sys        sysfs  defaults       0    0
devpts         /dev/pts    devpts gid=4,mode=620 0    0
tmpfs          /run        tmpfs  defaults       0    0
# End /etc/fstab
EOF

