docker run --name zabbix-web-nginx --hostname zabbix-web-nginx \
--link zabbix-mysql-server:mysql \
--link zabbix-server:zabbix-server \
-v /etc/localtime:/etc/localtime:ro \
-e DB_SERVER_HOST="mysql" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="Passw0rd" \
-e MYSQL_DATABASE="zabbix" \
-e ZBX_SERVER_HOST="zabbix-server" \
-e PHP_TZ="Asia/Shanghai" \
-p 8000:80 \
-p 8443:443 \
-d \
zabbix/zabbix-web-nginx-mysql
