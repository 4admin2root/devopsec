#!/bin/bash

cd /data/dailycheck
if [ $? -ne 0 ]
then 
  mkdir /data/dailycheck
  chmod ugo+w /data/dailycheck
  cd /data/dailycheck
fi
HOSTN=`hostname`
DATET=`date +%Y%m%d%H%M%S`
DATE=`date +"%Y-%m-%d %H:%M:%S"`
#if [ $# -eq 3 ]
#then
#threshold value setting
#need to change
IP_LIST="localhost.localdomain"

#system env
export ORACLE_BASE=/u01/app/oracle
#need to change
ORACLE_SID=gxb
export ORACLE_SID
ORACLE_DB_NAME=gxb
expoet ORACLE_DB_NAME
ORACLE_HOME=/u01/app/oracle/product/10.2.0/db_1
export ORACLE_HOME
export ORA_CRS_HOME=/u01/app/oracle/product/10.2.0/crs
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
PATH=$ORACLE_HOME/bin:$ORA_CRS_HOME/bin:$PATH
export PATH
#need to change
ORACLE_ASM_SID=+ASM2
export LANG=en_US.GBK
logpath=/data/dailycheck/`date +%Y%m%d`
FILENAME=${HOSTN}_ORA_${DATET}.txt
SPOOLFILE=$logpath/$FILENAME
if [ ! -d $logpath ]; then
   mkdir $logpath
   chmod ugo+w $logpath
fi
chmod 700 oracle_rac_chk_v1.sh
sqlplus -S /nolog <<EOF
connect / as sysdba
set lines 150
spool ${SPOOLFILE}
prompt----------------------------------------------------------------------

prompt|                                                                     |
prompt|                                                                     |
prompt|                                                                     |
prompt|                       Oracle Daily Check                            |
prompt|                                                                     |
prompt|                                                                     |
prompt|                                                                     |

prompt-----------------------------------------------------------------------

prompt ${DATE}
prompt                                                                                                                                                  
prompt ################### start sql script ###############
prompt ################### instance
prompt select count(*) from v\$instance
set serverout on
declare 
resnum number;
begin
select count(*) into resnum from gv\$instance;
if resnum < 1 then
dbms_output.put_line('check result:database instance_num exception');
else
dbms_output.put_line('check result:database instance_num normal');
end if;
end;
/
prompt ################## sga
show sga;
prompt ################## archive log
archive log list;
prompt ################## pga
select inst_id,name ,value/1024/1024/1024 from gv\$sysstat where name like '%pga%';
prompt ################## tablespace
set pages 999
set linesize 132
column status format A7
column type format A10
column tablespace_name format A20
column extent format A6
column space format A6
column allocation format A10
column next_extent format 999999999
select  t0.status "status",
	t0.contents "type",
	t0.extent_management "extent",
	t0.SEGMENT_SPACE_MANAGEMENT "space",
        t0.ALLOCATION_TYPE "allocation",
	t0.tablespace_name "tablespace_name",
	t2.tablespace_size "tablespace_size(M)",
	t2.tablespace_size - nvl(t1.free_size,0) "used_size(M)",
	nvl(t1.free_size,0) "free_size(M)",
	round((t2.tablespace_size - nvl(t1.free_size,0))*100/t2.tablespace_size,2) "used_percentage(%)"
from    dba_tablespaces t0,
	(select tablespace_name,round(sum(bytes)/1024/1024) free_size from dba_free_space group by tablespace_name) t1,
	(select tablespace_name,round(sum(bytes)/1024/1024) tablespace_size from dba_data_files group by tablespace_name) t2
where   t0.tablespace_name = t1.tablespace_name(+) and
	t0.tablespace_name = t2.tablespace_name(+) and not
	(t0.extent_management like 'LOCAL' and t0.contents like 'TEMPORARY')
union all
select  t0.status "status",
	t0.contents "type",
	t0.extent_management "extent",
	t0.SEGMENT_SPACE_MANAGEMENT "space",
    t0.ALLOCATION_TYPE "allocation",
	t0.tablespace_name "tablespace_name",
	t2.tablespace_size "tablespace_size(M)",
	nvl(t1.used_size,0) "used_size(M)",
	t2.tablespace_size - nvl(t1.used_size,0) "free_size(M)",
	round(nvl(t1.used_size,0)*100/t2.tablespace_size,2) "used_percentage(%)"
from    dba_tablespaces t0,
	(select tablespace_name,round(sum(bytes_cached)/1024/1024) used_size from v\$temp_extent_pool
		group by tablespace_name) t1,
	(select tablespace_name,round(sum(bytes)/1024/1024) tablespace_size from dba_temp_files group by tablespace_name) t2
where   t0.tablespace_name = t1.tablespace_name(+) and
	t0.tablespace_name = t2.tablespace_name(+) and
	t0.extent_management like 'LOCAL' and
	t0.contents like 'TEMPORARY'
order by "type","used_percentage(%)" desc;
prompt #################### size of datafiles tempfiles and logfiles
select round(sum(space)) all_space_M from 
(select sum(bytes)/1024/1024 space from dba_data_files
union all
select nvl(sum(bytes)/1024/1024,0) space from dba_temp_files
union all
select sum(bytes)/1024/1024 space from v\$log);
prompt ################### dba_segments
select round(sum(bytes)/1024/1024) from dba_segments;
prompt ################### tables or indexes where size + 800MB
col segment_name for a30
col segment_type for a15
  select segment_name,segment_type,bytes/1024/1024 from dba_segments where owner='SINOSOFT' and bytes/1024/1024>800 
  order by bytes/1024/1024 desc;
prompt ################## session
col machine for a25
col program for a25
col username for a8
col sid for 999
col serial# for 99999
select s.SID,s.SERIAL#,s.USERNAME,s.STATUS,s.MACHINE,s.PROGRAM,s.LOGON_TIME,s.EVENT from v\$session s where username is not null;
select count(*),program from v\$session where username is not null group by program;
select count(*),machine from v\$session where username is not null group by machine;
prompt ################## invalid index
select owner,index_name,index_type,status from dba_indexes where status='UNUSABLE';
select index_owner,index_name,status from dba_ind_partitions where status='UNUSABLE';
declare 
resnum number;
begin
select count(*) into resnum  from dba_indexes where status='UNUSABLE';
select count(*) + resnum into resnum from dba_ind_partitions where status='UNUSABLE';
if resnum > 0 then
dbms_output.put_line('check result:INDEX exception');
else
dbms_output.put_line('check result:INDEX normal');
end if;
end;
/
spool off
exit
EOF
echo "##################### lsnrctl status" >> ${SPOOLFILE}
lsnrctl status >> ${SPOOLFILE}
lsnrctl status > .ora_check.tmp
errnum=0
for i in $IP_LIST
do
errnumc=`cat .ora_check.tmp |grep $i|wc -l|awk '{print ($1==2)?"0":"1"}'`
errnum=`expr $errnum + $errnumc`
done
errnumc=`cat .ora_check.tmp |grep 'Service "gxb"' |wc -l|awk '{print ($1==1)?"0":"1"}'`
#it is not for static service registration
errnum=`expr $errnum + $errnumc`
if [ $errnum -gt 0 ];then
	echo "check result:listener status exception" >> ${SPOOLFILE}
else
	echo "check result:listener status normal" >> ${SPOOLFILE}
fi

echo "##################### alert.log" >> ${SPOOLFILE}
cat /u01/app/oracle/admin/gxb/bdump/alert_${ORACLE_SID}.log >> /u01/app/oracle/admin/gxb/bdump/alert_${ORACLE_SID}_${DATET}.log
> /u01/app/oracle/admin/gxb/bdump/alert_${ORACLE_SID}.log
errnum=`cat /u01/app/oracle/admin/gxb/bdump/alert_${ORACLE_SID}_${DATET}.log |grep -E 'ORA-|WARNING' |tee -a ${SPOOLFILE}|wc -l`
if [ $errnum -gt 0 ]; then
	echo "check result:ALERT log exception">> ${SPOOLFILE}
else
	echo "check result:ALERT log normal">> ${SPOOLFILE}
fi
echo "##################### du -ks dump" >> ${SPOOLFILE}
errnum=`du -ks $ORACLE_BASE/admin/$ORACLE_DB_NAME |tee -a ${SPOOLFILE}|awk '{print $1}'`
if [ $errnum -gt 8000000 ]; then
    echo "check result:dump files used space more than 8G,exception" >> ${SPOOLFILE}
else
    echo "check result:dump files used space normal" >> ${SPOOLFILE}
fi

echo "##################### find -type f dump |wc " >> ${SPOOLFILE}
errnum=`find $ORACLE_BASE/admin/$ORACLE_DB_NAME -type f |wc -l|tee -a ${SPOOLFILE}`
if [ $errnum -gt 20000 ]; then
    echo "check result:dump files_num  more than 20000,exception" >> ${SPOOLFILE}
else
    echo "check result:dump files_num  normal" >> ${SPOOLFILE}
fi

echo "##################### rman" >> ${SPOOLFILE}
rmanlog=/backup/rman/log/`date -d yesterday +%Y%m%d`.log
errnum=`cat $rmanlog|grep "Finished backup"|wc -l`
if [ $errnum -gt 1 ]; then
    echo "check result:RMAN backup log normal">> ${SPOOLFILE}
else
    echo "check result:RMAN backup log exception">> ${SPOOLFILE}
fi

