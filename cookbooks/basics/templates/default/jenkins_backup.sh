#!/bin/bash

# This script will be backing up jenkins and moving the backups to nfs mount in amazon raided server. 

DATE=`date +%F`
HOST=`hostname`
DIR="/backups/$HOST"
FILENAME="jenkins-$DATE.tgz"
rm -f $DIR/backup_error
find $DIR -type f -mtime +3 | xargs rm -f
tar -czvf $DIR/$FILENAME /var/lib/jenkins
if [ $? != 0 ]; then
{
    echo "BACKUP ERROR: problem backing up jenkins server"
    touch $DIR/backup_error
    exit 1
} fi
