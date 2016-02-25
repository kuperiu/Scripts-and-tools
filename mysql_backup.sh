#!/bin/bash
<<COMMENT
This script backups and archive mysql database

1. list database
2. backup and check
3. archive and check
4. archive integrity check
COMMENT

dumps_dir="/opt/mysql_backup/backups"
logs_dir="/opt/mysql_backup/logs"
status_file="/opt/status.txt"
date=$(date +"%Y_%m_%d")


logger () {
 case "$1" in
  1) echo "$(date) $2 database backup is starting" >> $logs_dir/"$date".log
  ;;
  2) echo "$(date) $2 database is skipped" >> $logs_dir/"$date".log
  ;;
  3) echo "$(date) $2 database backup has failed" >> $logs_dir/"$date".log
     echo "0" > $status_file
  ;;
  4) echo "$(date) $2 database archive is starting" >> $logs_dir/"$date".log
  ;;
  5) echo "$(date) $2 database archive has failed" >> $logs_dir/"$date".log
     echo "0" > $status_file
  ;;
  6) echo "$(date) $2 database archive was successful" >> $logs_dir/"$date".log
  ;;
  7) echo "$(date) $2 database archive integrity check has failed" >> $logs_dir/"$date".log
     echo "0" > $status_file
  ;;
 esac
}
archive () {
 logger 4 $1
 gzip $dumps_dir/"$1"_$date.sql
 if [ $? -eq 0 ]; then
  gzip -t $dumps_dir/"$1"_$date.sql.gz
  if [ $? -eq 0 ]; then
   logger 6 $1
  else
   logger 7 $1
  fi
 else
  logger 5 $1
 fi
}
backup () {
 logger 1 $1
 mysqldump --single-transaction --events $database > $dumps_dir/"$1"_$date.sql
 if [ $? -eq 0 ]; then
  archive $1
 else
  logger 3 $1
 fi
}
#create a directory for the dumps
if [ ! -d "$dumps_dir" ]; then
 mkdir -p $dumps_dir
fi
#create a directory for the logs
if [ ! -d "$logs_dir" ]; then
 mkdir -p $logs_dir
fi

echo "1" > $status_file
databases=$(mysql -N -s -e "SHOW DATABASES")
for database in ${databases[@]}; do
 if [[ "$database" = "information_schema" ]]; then
  logger 2 $database
 elif [[ "$database" = "performance_schema" ]]; then
  logger 2 $database
 else
  backup $database
 fi
Done
