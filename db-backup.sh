#!/bin/sh
# System + MySQL backup script
### System Setup ###
BACKUP=/var/www/tools/db/backups

### Mysql ### [params mysql]
MUSER=""
MPASS=""
MHOST="localhost"

### Binaries ###
TAR="$(which tar)"
GZIP="$(which gzip)"
FTP="$(which ftp)"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"

## Today + hour in 24h format ###
NOW=$(date +%Y%m%d)

### Create temp dir ###
mkdir $BACKUP/$NOW

### name Mysql ###
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do

  ### ###
  mkdir $BACKUP/$NOW/$db

 for i in `echo "show tables" | $MYSQL -u $MUSER -h $MHOST -p$MPASS $db|grep -v Tables_in_`;
   do
     FILE=$BACKUP/$NOW/$db/$i.sql.gz
     echo $i; $MYSQLDUMP --add-drop-table --allow-keywords -q -c -u $MUSER -h $MHOST -p$MPASS $db $i | $GZIP -9 > $FILE
   done
done

ARCHIVE=$BACKUP/mysql-$NOW.tar.gz
ARCHIVED=$BACKUP/$NOW

$TAR -zcvf $ARCHIVE $ARCHIVED
rm -rf $ARCHIVED

### clear ###
#find $BACKUP -mtime +2 -exec rm -rf '{}' \;
