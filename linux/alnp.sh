#!/bin/sh -e
#   --------------------------------------------------------------
#	系统支持: Alpine 3.10
#	作    者: feixiang
#	博    客: https://www.sbblog.cn/
#	基于Alpine一键安装 Nginx+PHP7+Sqlite3 环境 （支持VPS最小内存32M）
#	开源地址：https://github.com/sbblog/file/linux
#   --------------------------------------------------------------

echo -e "系统支持: Alpine 3.10"
echo -e "作    者: feixiang"
echo -e "博    客: https://www.sbblog.cn/"
echo -e "基于Alpine一键安装 Nginx+PHP7+Sqlite3 环境 （支持VPS最小内存32M）"
echo -e "开源地址：https://github.com/sbblog/file/linux"
echo -e ""
echo -e ""
echo -e ""

apk update

# 安装 nginx
apk add nginx
rm /etc/nginx/conf.d/default.conf
wget -P /etc/nginx/conf.d https://raw.githubusercontent.com/sbblog/file/master/linux/conf/default.conf

# 安装 php7 和 sqlite数据库
apk add php7 php7-mysqli php7-pdo_mysql php7-mbstring php7-json php7-zlib php7-gd php7-intl php7-session php7-fpm php7-memcached php7-tokenizer php7-ctype php7-sqlite3 php7-pdo_sqlite

# 创建目录
mkdir /home/wwwroot
mkdir /home/wwwroot/default

# 重启php7 并添加开机启动
/etc/init.d/php-fpm7 restart
rc-update add php-fpm7

# 重启nginx 并添加开机启动
/etc/init.d/nginx restart
rc-update add nginx

cat > /home/wwwroot/default/index.php << EOF
<?php phpinfo(); ?>
EOF

echo -e ""
echo -e ""
echo -e ""
echo -e "安装完成，通过IPv4即可访问默认页面，如果你是nat vps 或者 IPv6的vps"
echo -e "请修改 /etc/nginx/conf.d/default.conf 删除第六行的 #"
echo -e "修改nginx的配置文件，每次都需要重启nginx才会生效：/etc/init.d/nginx restart"
echo -e "重启php7的命令是：/etc/init.d/php-fpm7 restart"
echo -e "默认路径：/home/wwwroot/default，你可以把程序放在这里面。"
