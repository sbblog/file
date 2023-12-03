#!/bin/bash
#
# Caddy Web Server Installer
# https://github.com/sayem314/Caddy-Web-Server-Installer
#
echo "  Setting timezone..."
rm -rf /etc/localtime
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

apt-get install curl lsb-release -y

if [[ -e "/usr/local/bin/caddy" ]]; then
	echo ""
	echo "  Removing old Caddy script"
	rm -f /usr/local/bin/caddy
fi
echo ""
echo "  Setting up Caddy"
cd /tmp
wget -q https://raw.githubusercontent.com/sayem314/Caddy-Web-Server-Installer/master/caddy
chmod +x caddy; mv caddy /usr/local/bin;
echo "  Done. run 'caddy' to use Caddy"
echo ""
exit;
