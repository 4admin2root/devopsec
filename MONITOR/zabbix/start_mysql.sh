#!/usr/bin/bash
docker run --name zabbix-mysql-server --hostname zabbix-mysql-server \
-v /etc/localtime:/etc/localtime:ro \
-v /opt/docker/mysql/datadir:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD="Passw0rd" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="Passw0rd" \
-e MYSQL_DATABASE="zabbix" \
-p 3306:3306  \
-d \
mysql:5.7 \
--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
