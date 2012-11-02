#!/bin/bash

# This script will be backing up mysql and moving the backups to nfs mount in amazon raided server. 

DATE=`date +%F`
HOST=`hostname`
DIR="/backups/$HOST"
TMP="$DIR/tmp"
FILENAME="mysql_db-$DATE.tgz"
rm -f $DIR/backup_error
mysqldump -uroot mysql > $TMP/mysql.sql
mysqldump -uroot choochee_users_db > $TMP/choochee_users_db.sql
mysqldump -uroot dialer_db > $TMP/dialer_db.sql
mysqldump -uroot opensips > $TMP/opensips.sql
find $DIR -type f -mtime +30 | xargs rm -f
tar -czvf $DIR/$FILENAME $TMP/*.sql
rm -f $TMP/*.sql
if [ $? != 0 ]; then
{
    echo "BACKUP ERROR: problem backing up mysql server"
    touch $DIR/backup_error
    exit 1
} fi
