#!/bin/sh -e
#   --------------------------------------------------------------
#	系统支持: Alpine 3.10+
#	作    者: sbblog
#	博    客: https://www.sbblog.cn/
#	开源地址：https://github.com/sbblog/file/linux
#	基于Alpine一键安装 Caddy+PHP7+Sqlite3 环境 （支持VPS最小内存32M，建议64M内存起步）
#   --------------------------------------------------------------

apk update

apk add -u tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

apk add caddy

apk add php7 php7-ctype php7-curl php7-dom php7-fpm php7-iconv php7-gd php7-json php7-mysqli php7-openssl php7-pdo php7-pdo_sqlite php7-sqlite3 php7-xml php7-xmlreader php7-zlib php7-phar php7-posix php7-ftp php7-session php7-bcmath php7-mcrypt php7-sockets php7-mbstring php7-wddx php7-fileinfo 

sed -i 's@^;date.timezone.*@date.timezone = Asia/Shanghai@' /etc/php7/php.ini
sed -i "s@^memory_limit.*@memory_limit = 16M@" /etc/php7/php.ini
sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini

mkdir -p /home/www/default
mkdir -p /home/run
mkdir -p /home/log

cat > /home/www/default/index.php << EOF
<?php phpinfo(); ?>
EOF

rm /etc/php7/php-fpm.conf
wget -P /etc/php7 https://raw.githubusercontent.com/sbblog/file/master/linux/conf/php-fpm.conf

cat > /etc/caddy/caddy.conf << EOF
:80 {
    gzip
    root /home/www/default
    fastcgi / /home/run/php-fpm.sock php
}
EOF

chown -R caddy:caddy /home/*

service php-fpm7 start
service caddy start

rc-update add php-fpm7 default
rc-update add caddy default

netstat -ntlp

echo -e ""
echo -e ""
echo -e ""
echo -e "安装完成，Caddy默认监听IPv4和IPv6，请使用IP访问默认页面"
echo -e "程序默认路径：/home/www/default，你可以把程序放在这里面。也可以在/home/www/下面新建文件夹。"
echo -e "如果程序放到了指定目录无法提示没有权限，执行下：chown -R caddy:caddy /home/*   "
echo -e "修改/etc/caddy/caddy.conf 绑定多个域名，修改完后运行：service caddy restart "
echo -e "PHP组件基本都装的差不多了，如果你还要安装其他组件，安装完后要重启下PHP，运行：service php-fpm7 restart "
