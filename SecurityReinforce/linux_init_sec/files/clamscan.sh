#!/bin/bash
mkdir /tmp/av
LOG=/tmp/av/`hostname`_`date +%Y%m%d`_av.log
clamscan --infected  --recursive /opt /data /data1 >> $LOG
if [ `grep Infected $LOG |awk '{print $3}'` -gt 0 ]
then
cat $LOG | mail -s `hostname`_antivirus_result ops@synjones.net
fi
