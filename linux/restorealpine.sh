#!/bin/sh -e
# Converts OpenVZ VPS to Alpine Linux
# WARNING: This script will wipe any data in your VPS!
# GPLv2; Partly based on https://gitlab.com/drizzt/vps2arch

rm -rf /x
rm -f /rootfs.tar.xz;




mkdir /x
tar xzf $1 -C /x
cd /
 
sed -i '/getty/d' /x/etc/inittab
sed -i 's/rc_sys="lxc"/rc_sys="openvz"/' /x/etc/rc.conf

# save root password and ssh directory
sed -i '/^root:/d' /x/etc/shadow
grep '^root:' /etc/shadow >> /x/etc/shadow
[ -d /root/.ssh ] && cp -a /root/.ssh /x/root/

# save network configuration
dev=venet0
ip=$(ip addr show dev $dev | grep global | awk '($1=="inet") {print $2}' | cut -d/ -f1 | head -1)
hostname=$(hostname)
 
cat > /x/etc/network/interfaces << EOF
auto lo
iface lo inet loopback
 
auto $dev
iface $dev inet static
address $ip
netmask 255.255.255.255
up ip route add default dev $dev
 
hostname $hostname
EOF
cp /etc/resolv.conf /x/etc/resolv.conf
 
# remove all old files and replace with alpine rootfs
find / \( ! -path '/dev/*' -and ! -path '/proc/*' -and ! -path '/sys/*' -and ! -path '/x/*' \) -delete || true
 
/x/lib/ld-musl-x86_64.so.1 /x/bin/busybox cp -a /x/* /
export PATH="/usr/sbin:/usr/bin:/sbin:/bin"
 
rm -rf /x
 
apk update
apk add openssh
echo PermitRootLogin yes >> /etc/ssh/sshd_config
rc-update add sshd default
rc-update add mdev sysinit
rc-update add devfs sysinit
#sh # (for example, run `passwd`)

sync
reboot -f