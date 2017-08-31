# tomcat catalina.sh
```
AGENT_PATH=/opt/xzx/app/pinpoint-agent/
VERSION=1.6.0
AGENT_ID=6
APPLICATION_NAME=UP_PROD_TOM
#CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote.password.file=/etc/zabbix/jmxremote.password -Dcom.sun.management.jmxremote.access.file=/etc/zabbix/jmxremote.access -Dcom.sun.management.jmxremote.ssl=false"
CATALINA_OPTS="$CATALINA_OPTS -javaagent:$AGENT_PATH/pinpoint-bootstrap-$VERSION.jar"
CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.agentId=$AGENT_ID"
CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.applicationName=$APPLICATION_NAME"
```
