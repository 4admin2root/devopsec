# command example for jar

/usr/java/jdk1.7.0_80/bin/java -javaagent:/opt/xzx/app/pinpoint-agent/pinpoint-bootstrap-1.6.0.jar -Dpinpoint.agentId=15 -Dpinpoint.applicationName=UP_PROD_INFO -server -Xmx2g -Xms2g -Xmn256m -XX:PermSize=128m -Xss256k -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -jar /opt/xzx/app/information_service_svc/current/information_service_svc-1.0.1.jar
