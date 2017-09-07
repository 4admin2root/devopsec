#!/usr/bin/bash
#docker run --name zabbix-agent \
#--privileged \
#-v /etc/localtime:/etc/localtime:ro \
#--link zabbix-server:zabbix-server \
#-d \
#zabbix/zabbix-agent
##############
docker run --name some-zabbix-agent \
--privileged \
-v /etc/localtime:/etc/localtime:ro \
-e ZBX_HOSTNAME="some-zabbix-agent" \
-e ZBX_SERVER_HOST="10.9.5.11" \
-d \ 
zabbix/zabbix-agent
###########
#then go to zabbix templates
# select Template OS Linux, full clone
# change name to Template OS Linux active
# mass update all items and discovery rules to zabbix agent(active)
# Unlink and clear template named App Zabbix Agent


