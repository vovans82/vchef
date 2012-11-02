#!/bin/bash

# Input: name of backup file (optional); like /backups/chef006.rs1.inf.choochee.com/chef-2012-04-03.tgz
# if not specified it will use the latest backup file in BACKUPDIR

BACKUPDIR="/backups/chef006.rs1.inf.choochee.com"
LATESTBACKUP=`cd ${BACKUPDIR}; ls -tr *.tgz | tail -1`
WRK="/tmp/chef_server_restore"
STAMP=`date +%s`

if [ ${1} ]; then 
  BACKUPFILE=${1}
  if [ ! -f ${BACKUPFILE} ]; then
    echo "ERROR: backups file ${BACKUPFILE} doesn't exit"
    exit 1
  fi
else
  BACKUPFILE=${BACKUPDIR}/${LATESTBACKUP}
fi

function stop_services {
  echo "Stopping chef server services..."
  for s in server server-webui solr expander; do /etc/init.d/chef-${s} stop; done
  killall -9 chef-server
  for i in couchdb rabbitmq-server nginx; do /etc/init.d/${i} stop; done
}

function start_services {
  echo "Starting chef server services..."
  for i in couchdb rabbitmq-server nginx; do /etc/init.d/${i} start; done
  for s in server server-webui solr expander; do sudo /etc/init.d/chef-${s} start; done
}

function init_wrk {
  if [ -e ${WRK} ]; then
    echo "Cleanup old ${WRK} env.."
    rm -rf ${WRK}
  fi
  mkdir -p ${WRK}
  echo "Copying backup file ${BACKUPFILE} to ${WRK}..."
  cp ${BACKUPFILE} ${WRK}/
  echo "Uncompressing backup file..."
  cd ${WRK}
  tar -zxf *.tgz
}

function backup_old {
  echo "Saving old data... just in case ;)..."
  for f in chef couchdb; do mv /var/lib/${f} /var/lib/${f}-${STAMP}; done
}

function copy_data {
  echo "Copying chef server files from backup..."
  # Actually move them as it is faster than copying and we don't need the temp files after that anyway
  for f in chef couchdb; do mv ${WRK}/var/lib/${f} /var/lib/${f}; done
}

echo "Restoring chef server from backup file: ${BACKUPFILE}"
stop_services
init_wrk
backup_old
copy_data
start_services
echo "Restore completed and all chef services are up and running"
