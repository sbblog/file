# 脚本说明
-----
感谢刺客提供一下脚本 https://cikeblog.com

其他linux重装成alpine

wget --no-check-certificate -O alpine-install.sh https://git.io/JeD5I && bash alpine-install.sh

alpine里面执行，还原初始系统

wget --no-check-certificate -O alpine-reinstall.sh https://git.io/JeD5j && chmod 755 alpine-reinstall.sh &&./alpine-reinstall.sh

备份恢复

wget --no-check-certificate -O alpine-restore.sh https://git.io/JeDdK && chmod 755 alpine-restore.sh &&./alpine-restore.sh

-----

上面的重装和还原成alpine都是3.9版，目前最新版本是3.10.3。

所以有了下面的脚本，一键更新alpine到3.10.3，并更新时区为上海。

apk add ca-certificates&& update-ca-certificates && apk --no-cache add openssl wget && wget --no-check-certificate -O alpine-update.sh https://git.io/JeDdM && chmod 755 alpine-update.sh &&./alpine-update.sh
