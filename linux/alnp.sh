#!/bin/sh -e
#   --------------------------------------------------------------
#	系统支持: Alpine 3.10
#	作    者: feixiang
#   博    客: https://www.sbblog.cn/
#	基于Alpine一键安装 Nginx+PHP7+Sqlite3 环境 （支持VPS最小内存32M）
#	开源地址：https://github.com/sbblog/file/linux
#   --------------------------------------------------------------

echo -e "系统支持: Alpine 3.10"
echo -e "作    者: feixiang"
echo -e "博    客: https://www.sbblog.cn/"
echo -e "基于Alpine一键安装 Nginx+PHP7+Sqlite3 环境 （支持VPS最小内存32M）"
echo -e "开源地址：https://github.com/sbblog/file/linux"

apk update

# 创建目录
mkdir /home/wwwroot
mkdir /home/wwwroot/default

# 安装 nginx
apk add nginx
rm /etc/nginx/conf.d/default.conf
cat > /etc/nginx/conf.d/default.conf << EOF
# This is a default site configuration which will simply return 404, preventing
# chance access to any other virtualhost.

server {
        listen 80 default_server;
        #listen [::]:80 default_server ipv6only=on;
        server_name _;
        index index.html index.htm index.php;
        root /home/wwwroot/default;

        location ~ [^/]\.php(/|$) {
                fastcgi_index index.php;
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }

        # You may need this to prevent return 404 recursion.
        location = /404.html {
                internal;
        }
}
EOF
# 安装 php7 和 sqlite数据库
apk add php7 php7-mysqli php7-pdo_mysql php7-mbstring php7-json php7-zlib php7-gd php7-intl php7-session php7-fpm php7-memcached php7-tokenizer php7-ctype php7-sqlite php7-pdo_sqlite

# 重启nginx 并添加开机启动
/etc/init.d/nginx restart
rc-update add nginx

# 重启php7 并添加开机启动
/etc/init.d/php-fpm7 restart
rc-update add php-fpm7

cat > /home/wwwroot/default/index.php << EOF
<?php phpinfo(); ?>
EOF