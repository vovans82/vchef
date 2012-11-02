#!/bin/bash

src=/choochee
dest=/backups/repo001.rs1.inf.choochee.com
src2=/etc/nginx
date=`date +%F`
log="/var/log/repo_backup.log"

echo "---" $date "-------------------" >> $log

rsync -l -t -r -v --delete $src $dest >> $log

echo "--------------- END ---------------" >> $log
echo "---" $date "-------------------" >> $log

rsync -l -t -r -v --delete $src2 $dest >> $log

echo "--------------- END ---------------" >> $log
if [ $? != 0 ]; then
{
    echo "BACKUP ERROR: problem backing up repo server"
    touch $dest/backup_error
    exit 1
} fi
