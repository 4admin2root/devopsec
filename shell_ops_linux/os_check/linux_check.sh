#!/bin/bash
##
if [ $# -ne 1 ]
then
echo "SYNOPSIS:linux_check.sh HOSTNAME"
exit
fi
FILENAME=`hostname`_OS_`date +%Y%m%d%H%M%S`.txt
cd /data/dailycheck
if [ $? -ne 0 ]
then 
  mkdir /data/dailycheck
  chmod ugo+w /data/dailycheck
  cd /data/dailycheck
fi

logpath=/data/dailycheck/`date +%Y%m%d`
if [ ! -d $logpath ]; then
   mkdir $logpath
   chmod ugo+w $logpath
fi

cd $logpath

export LANG=en_US
export SHELL=/bin/bash

systemname=`uname -o`

hostname=$1

chk_001_name="hostname"
chk_result_001=0

chk_002_name="filesystem use ratio"
chk_result_002=0

chk_003_name="host alive time"
chk_result_003=0

chk_004_name="CPU use ratio"
chk_result_004=0

chk_005_name="MEM use ratio"
chk_result_005=0

chk_006_name="SWAP use ratio"
chk_result_006=0

chk_007_name="ethernet status"
chk_result_007=0

chk_008_name="network status"
chk_result_008=0

chk_009_name="messages log"
chk_result_009=0

# total check result
chk_result=0

#limits  
MAX_DF_USED=80
MIN_UPTIME=172800
MIN_CPU_IDLE=8
MAX_MEM_USED=99
MAX_SWAP_USED=50

# ethernet device name
#ETH_LIST="eth0 eth1 eth2 eth3"
ETH_LIST="eth0 eth1"
MIN_LISTEN_NUM=2         # min_num of the LISTEN port 
MIN_ESTABLISH_NUM=0      # min_num of the ESTABLISHED port
MAX_TIMEWAIT_NUM=30      # max_num of the TMME_WAIT port

echo "----------------------------------------------------------------------" >> $FILENAME 
echo "|                                                                     |" >> $FILENAME 
echo "|                                                                     |" >> $FILENAME 
echo "|                                                                     |" >> $FILENAME 
echo "|                       Linux Daily Check                             |" >> $FILENAME 
echo "|                                                                     |" >> $FILENAME 
echo "|                                                                     |" >> $FILENAME 
echo "|                                                                     |" >> $FILENAME 
echo "----------------------------------------------------------------------" >> $FILENAME
echo "Starting data collection,it may take a few minutes!"
echo "" >> $FILENAME 
echo `date +"%Y-%m-%d %H:%M:%S"` >> $FILENAME
date

echo =========================================================>>$logpath/$FILENAME

#hostname
echo $systemname"_001."$chk_001_name>>$logpath/$FILENAME
echo '#hostname'>>$logpath/$FILENAME
echo 'hostname' $hostname >>$logpath/$FILENAME
hostname>>$logpath/$FILENAME
chk_result_001=0
if [ x$hostname != x`hostname` ]; then
    echo "check result:exception,hostname[`hostname`],normal hostname shall be[$hostname]">>$logpath/$FILENAME
    chk_result_001=1
else
    echo "check result:hostname normal">>$logpath/$FILENAME
    chk_result_001=0
fi


echo =========================================================>>$logpath/$FILENAME

#filesystem use ratio
echo $systemname"_002."$chk_002_name>>$logpath/$FILENAME
echo '#df'>>$logpath/$FILENAME
echo 'MAX_DF_USED' $MAX_DF_USED >>$logpath/$FILENAME
df -P>>$logpath/$FILENAME
errnum=`df -P|grep -v Capacity |awk '{print $5}'|sed -e 's/\%//g'|awk '{if ($1>=myvar) printf  "%s\n",$1}' myvar=$MAX_DF_USED|wc -l`
if [ $errnum -eq 0 ]; then
    chk_result_002=0
    echo "check result:filesystem use ratio normal" >> $logpath/$FILENAME
else
    chk_result_002=1
    echo "check result:filesystem use ratio exception" >> $logpath/$FILENAME
fi


echo =========================================================>>$logpath/$FILENAME

#host alive time
echo $systemname"_003."$chk_003_name>>$logpath/$FILENAME
echo '#uptime'>>$logpath/$FILENAME
echo 'MIN_UPTIME' $MIN_UPTIME>>$logpath/$FILENAME
uptime >> $logpath/$FILENAME
errnum=`cat /proc/uptime|awk '{print($1>=myvar)?"0":"1"}' myvar=$MIN_UPTIME`
more /proc/uptime >>$logpath/$FILENAME
if [ $errnum -eq 0 ]; then
    chk_result_003=0
    echo "check result:host alive time normal" >> $logpath/$FILENAME
else
    chk_result_003=1
    echo "check result:host alive time exception" >> $logpath/$FILENAME
fi

echo =========================================================>>$logpath/$FILENAME

#CPU use ratio 
echo $systemname"_004."$chk_004_name>>$logpath/$FILENAME
echo '#sar -u'>>$logpath/$FILENAME
echo 'MIN_CPU_IDLE' $MIN_CPU_IDLE>>$logpath/$FILENAME
sar -u 2 5 >> $logpath/$FILENAME
cpurate=`sar -u 2 5 |grep Aver |awk '{print $8}'`
errnum=`echo $cpurate|awk '{print($1>=myvar)?"0":"1"}' myvar=$MIN_CPU_IDLE`
if [ $errnum -eq 1 ];then
    chk_result_004=1
    echo "check result:CPU use ratio exception" >> $logpath/$FILENAME
else
    chk_result_004=0
    echo "check result:CPU use ratio normal" >> $logpath/$FILENAME
fi


echo =========================================================>>$logpath/$FILENAME

#MEM use ratio 
echo $systemname"_005."$chk_005_name>>$logpath/$FILENAME
echo '#free'>>$logpath/$FILENAME
echo 'MAX_MEM_USED' $MAX_MEM_USED>>$logpath/$FILENAME
free >> $logpath/$FILENAME
memtotal=`free |grep Mem |awk '{print $2}'`
memused=`free |grep Mem |awk '{print $3}'`
memrate=`echo $memused $memtotal |awk '{print $1/$2*100}'`
errnum=`echo $memrate|awk '{print($1>=myvar)?"1":"0"}' myvar=$MAX_MEM_USED`
if [ $errnum -eq 1 ];then
     chk_result_005=1
     echo "check result:MEM use ratio exception" >> $logpath/$FILENAME
else
    chk_result_005=0
    echo "check result:MEM use ratio normal" >> $logpath/$FILENAME
fi

echo =========================================================>>$logpath/$FILENAME

#SWAP use ratio 
echo $systemname"_006."$chk_006_name>>$logpath/$FILENAME
echo '#free'>>$logpath/$FILENAME
echo 'MAX_SWAP_USED' $MAX_SWAP_USED>>$logpath/$FILENAME
swaptotal=`free |grep Swap |awk '{print $2}'`
swapused=`free |grep Swap |awk '{print $3}'`
swaprate=`echo $swapused $swaptotal |awk '{print $1/$2*100}'`
errnum=`echo $swaprate|awk '{print($1>=myvar)?"1":"0"}' myvar=$MAX_SWAP_USED`
if [ $errnum -eq 1 ];then
     chk_result_006=1
     echo "check result:SWAP use ratio exception" >> $logpath/$FILENAME
else
    chk_result_006=0
    echo "check result:SWAP use ratio normal" >> $logpath/$FILENAME
fi
echo =========================================================>>$logpath/$FILENAME

#etnernet status
echo $systemname"_007."$chk_007_name>>$logpath/$FILENAME
echo '#ethtool'>>$logpath/$FILENAME
errnum=0
for i in $ETH_LIST
do
ethtool $i >>$logpath/$FILENAME
errnumc=`ethtool $i|grep Link |grep yes|wc -l|awk '{print ($1==1)?"0":"1"}'`
errnum=`expr $errnum + $errnumc`
done
if [ $errnum -eq 1 ];then
     chk_result_007=1
     echo "check result:etnernet status exception" >> $logpath/$FILENAME
else
    chk_result_007=0
    echo "check result:etnernet status normal" >> $logpath/$FILENAME
fi

echo =========================================================>>$logpath/$FILENAME

#network status  
echo $systemname"_008."$chk_008_name>>$logpath/$FILENAME
echo '#netstat -an'>> $logpath/$FILENAME
errnum=0
netstat -an |grep ESTABLISHED >>$logpath/$FILENAME
echo 'MIN_ESTABLISH_NUM' $MIN_ESTABLISH_NUM >>$logpath/$FILENAME
errnumc=`netstat -an |grep ESTABLISHED|wc -l|awk '{print ($1>=myvar)?"0":"1"}' myvar=$MIN_ESTABLISH_NUM`
errnum=`expr $errnum + $errnumc`
netstat -an |grep TIME_WAIT >>$logpath/$FILENAME
echo 'MAX_TIMEWAIT_NUM' $MAX_TIMEWAIT_NUM >>$logpath/$FILENAME
errnumc=`netstat -an |grep TIME_WAIT|wc -l|awk '{print ($1<=myvar)?"0":"1"}' myvar=$MAX_TIMEWAIT_NUM`
errnum=`expr $errnum + $errnumc`
netstat -an |grep LISTEN >>$logpath/$FILENAME
echo 'MIN_LISTEN_NUM' $MIN_LISTEN_NUM >>$logpath/$FILENAME
errnumc=`netstat -an |grep LISTEN|wc -l|awk '{print ($1>=myvar)?"0":"1"}' myvar=$MIN_LISTEN_NUM`
errnum=`expr $errnum + $errnumc`
if [ $errnum -gt 0 ];then
     chk_result_008=1
     echo "check result:network status exception" >> $logpath/$FILENAME
else
    chk_result_008=0
    echo "check result:network status normal" >> $logpath/$FILENAME
fi


echo =========================================================>>$logpath/$FILENAME

#messages log
echo $systemname"_009."$chk_009_name>>$logpath/$FILENAME
echo '#cat /var/log/messages'>> $logpath/$FILENAME
cat /var/log/messages |grep -E 'EMERG|ALERT|CRIT|ERR|WARNING' >>$logpath/$FILENAME
errnum=`cat /var/log/messages |grep -E 'EMERG|ALERT|CRIT|ERR|WARNING'|grep -v logrotate|wc -l`

if [ $errnum -gt 0 ];then
     chk_result_009=1
     echo "check result:system log exception" >> $logpath/$FILENAME
else
    chk_result_009=0
    echo "check result:system log normal" >> $logpath/$FILENAME
fi

#save log files
chattr -a /var/log/messages
YDATE=`date +%Y%m%d%H%M%S`
mv /var/log/messages /var/log/messages.$YDATE
> /var/log/messages
chattr +i /var/log/messages.$YDATE
chattr +a /var/log/messages
EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t dailycheck "ALERT exited abnormally with [$EXITVALUE]"
fi


echo "Collection complete successfully!"
date

chk_result=`expr $chk_result + $chk_result_001`
chk_result=`expr $chk_result + $chk_result_002`
chk_result=`expr $chk_result + $chk_result_003`
chk_result=`expr $chk_result + $chk_result_004`
chk_result=`expr $chk_result + $chk_result_005`
chk_result=`expr $chk_result + $chk_result_006`
chk_result=`expr $chk_result + $chk_result_007`
chk_result=`expr $chk_result + $chk_result_008`
chk_result=`expr $chk_result + $chk_result_009`
echo "#####################################################################################">> $logpath/$FILENAME
echo "check result:has " $chk_result " warnning" >> $logpath/$FILENAME

#convert results to the server 
#lftp -u "root","pwd" sftp://10.2.8.189 <<EOF
#cd $logpath
#put $FILENAME
#exit
#EOF
find /var/log/ -name "messages.*" -size 0 -exec chattr -R -i {} \; -exec rm -f {} \;
