docker run --name zabbix-server --hostname zabbix-server \
--link zabbix-mysql-server:mysql \
-e DB_SERVER_HOST="mysql" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="Passw0rd" \
-v /etc/localtime:/etc/localtime:ro \
-v /opt/docker/zabbix/alertscripts:/usr/lib/zabbix/alertscripts \
-v /opt/docker/zabbix/externalscripts:/usr/lib/zabbix/externalscripts \
-p 10051:10051 \
-d \
zabbix/zabbix-server-mysql
