#!/bin/bash
mv -f /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
LOG=`hostname`_`date +%Y%m%d`.log
/sbin/aide -u >> /var/lib/aide/$LOG 
grep okay /var/lib/aide/$LOG
if [ $? -ne 0 ]
then
cat /var/lib/aide/$LOG | mail -s `hostname`_aide_result ops@synjones.net
fi
