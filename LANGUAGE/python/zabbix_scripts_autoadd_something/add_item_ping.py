#!/usr/bin/python 
# -*- coding:utf-8 -*-
"""
created by Jason Lui 
使用方法：
1 首先安装pyzabbix (pip install pyzabbix)
2 执行python add_item_ping.py 10.0.0.1 添加从zabbix server ping 10.0.0.1主机的连通性测试监测
3 如果需要添加多台主机，可编写shell进行循环调用上面的命令


"""

import sys
reload(sys)
sys.setdefaultencoding('utf8')

import re
from pyzabbix import ZabbixAPI, ZabbixAPIException

# 这里得改为相应的zabbix url，路径写全了
ZABBIX_SERVER = 'http://10.2.2.1'

zapi = ZabbixAPI(ZABBIX_SERVER)

# 这里得改为相应的用户名和密码
zapi.login('Admin', 'zabbix')

# 这里是zabbix server的主机名，默认是这个
host_name = 'Zabbix server'

ipaddr = sys.argv[1]

pattern = r"\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
if not re.match(pattern, ipaddr):
     sys.exit("ip error") 

hosts = zapi.host.get(filter={"host": host_name},selectInterfaces=["interfaceid"])

if hosts:
    host_id = hosts[0]["hostid"]
    print("Found host id {0}".format(host_id))
    try:
        item=zapi.item.create(
            hostid=host_id,
            name='ping $1',
            key_='icmpping['+ipaddr+',20,20,100,100]',
            type=3,
            value_type=3,
            interval=90,
            interfaceid=hosts[0]["interfaces"][0]["interfaceid"],
            delay=300
        )
    except ZabbixAPIException as e:
        print(e)
        sys.exit()
    print("Added item with itemid {0} to host: {1}".format(item["itemids"][0],host_name))
    try:
        item=zapi.trigger.create(
		hostid=host_id,
		description='ping '+ipaddr,
		status=0,
		type=0,
		priority=3,
		expression='{'+host_name+':'+'icmpping['+ipaddr+',20,20,100,100].last()}=0'
        )
    except ZabbixAPIException as e:
        print(e)
        sys.exit()
    print("Added trigger with triggerid {0} to host: {1}".format(item["triggerids"][0],host_name))
else:
    print("No hosts found")
