#!/bin/bash

if [ -z $MONGO_PASSWORD ]; then
  echo Il faut fournir le mot de passe mongo dans MONGO_PASSWORD
  exit 1
fi

BACKUP_MAPPED_FOLDER=/var/lib/backup_docker
DATE=`date +"%Y%m%d-%H%M"`
BACKUP_ROOT=/mnt/backup

# Preparer folder backup sur host
BACKUP_LEAF=backup_maple_$DATE
mkdir -p $BACKUP_MAPPED_FOLDER/$BACKUP_LEAF
chown mathieu:docker $BACKUP_MAPPED_FOLDER/$BACKUP_LEAF
chmod 770 $BACKUP_MAPPED_FOLDER/$BACKUP_LEAF

# Nom du folder backup dans container
BACKUP_FOLDER=$BACKUP_ROOT/$BACKUP_LEAF

IMAGE=mongo
COMMAND="mongodump --uri=mongodb://backup:$MONGO_PASSWORD@192.168.1.28 --ssl --sslAllowInvalidCertificates -o $BACKUP_FOLDER --oplog --gzip"

docker run -t --rm -v $BACKUP_MAPPED_FOLDER:$BACKUP_ROOT $IMAGE $COMMAND

if [ $? -eq 0 ]; then
  echo "Backup complete avec succes"
else
  exit 2
fi

