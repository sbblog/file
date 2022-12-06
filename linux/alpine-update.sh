#!/bin/sh -e
# The source of the update is official, and some areas may be slow.

apk update --allow-untrusted
apk upgrade --allow-untrusted

sync

rm  /etc/apk/repositories
cat > /etc/apk/repositories << EOF
http://dl-cdn.alpinelinux.org/alpine/latest-stable/main
http://dl-cdn.alpinelinux.org/alpine/latest-stable/community
EOF

apk update --allow-untrusted
apk upgrade --allow-untrusted

apk add -u tzdata --allow-untrusted
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

apk add openssh --allow-untrusted
echo PermitRootLogin yes >> /etc/ssh/sshd_config
rc-update add sshd default

echo -e "系统更新完成，当前alpine版本："
cat /etc/alpine-release
sleep 3
echo -e ""
echo -e "10秒后重启系统"
sleep 10

sync
reboot -f
