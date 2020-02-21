#!/bin/sh -e
# The source of the update is official, and some areas may be slow.

apk update
apk upgrade

sync

rm  /etc/apk/repositories
cat > /etc/apk/repositories << EOF
http://dl-cdn.alpinelinux.org/alpine/latest-stable/main
http://dl-cdn.alpinelinux.org/alpine/latest-stable/community
EOF

apk update
apk upgrade

apk add -u tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

apk add openssh
echo PermitRootLogin yes >> /etc/ssh/sshd_config

sync
reboot -f
