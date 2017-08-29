#!/usr/bin/python 
# -*- coding:utf-8 -*-
"""
created by Jason Lui 
使用方法：
1 首先安装pyzabbix (pip install pyzabbix)
2 执行python add_linux_host.py 10.0.0.1 添加host 10.0.0.1
3 如果需要添加多台主机，可编写shell进行循环调用上面的命令


"""

import sys
reload(sys)
sys.setdefaultencoding('utf8')

import re
from pyzabbix import ZabbixAPI, ZabbixAPIException


ZABBIX_SERVER = 'http://10.2.2.1'
zapi = ZabbixAPI(ZABBIX_SERVER)
zapi.login('Admin','zabbix')

ipaddr = sys.argv[1]

pattern = r"\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
if not re.match(pattern, ipaddr):
     sys.exit("ip error") 

hostgroup='added with python'
try:
        item=zapi.hostgroup.get(
        output="groupids",
        filter={"name" :hostgroup} 
        )
except ZabbixAPIException as e:
        print(e)
if item:
        gid=item[0]["groupid"]
else:
  try:
        item=zapi.hostgroup.create(
            name=hostgroup
        )
        gid=item["groupids"][0]
  except ZabbixAPIException as e:
        print(e)

interface={"type": 1, "main": 1, "useip": 1, "ip": ipaddr, "dns": "", "port": "10050"}
group={"groupid" : int(gid)}
template={"templateid" : 10001}
if  item: 
 try:
        item=zapi.host.create(
            host=ipaddr,
            interfaces=[interface],
            groups=[group],
            templates=[template]
    
        )
	print item["hostids"][0]
 except ZabbixAPIException as e:
        print(e)
