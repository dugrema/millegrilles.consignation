#!/bin/env bash

MONGO_PASSWORD=`cat /var/opt/millegrilles/secrets/passwd.mongo.txt`

#if [ -z $MONGO_PASSWORD ]; then
#  echo Il faut fournir le mot de passe mongo dans MONGO_PASSWORD
#  exit 1
#fi

#BACKUP_MAPPED_FOLDER=/var/lib/backup_docker
BACKUP_MAPPED_FOLDER="/home/mathieu/backup"
SECRETS=/var/opt/millegrilles/secrets
KEY_CERT_FILE="$BACKUP_MAPPED_FOLDER/mongo.key_cert"
DATE=`date +"%Y%m%d-%H%M"`
BACKUP_ROOT=/mnt/backup

# Preparer folder backup sur host
#BACKUP_LEAF=backup_maple_$DATE
BACKUP_LEAF=backup_maple
#sudo rm -r "$BACKUP_MAPPED_FOLDER/$BACKUP_LEAF"
#mkdir -p "$BACKUP_MAPPED_FOLDER/$BACKUP_LEAF"
#sudo chown 999:999 "$BACKUP_MAPPED_FOLDER/$BACKUP_LEAF"
#chmod 750 "$BACKUP_MAPPED_FOLDER/$BACKUP_LEAF"

cat /var/opt/millegrilles/secrets/pki.mongo.key > $KEY_CERT_FILE
cat /var/opt/millegrilles/secrets/pki.mongo.cert >> $KEY_CERT_FILE
cp /var/opt/millegrilles/configuration/pki.millegrille.cert $BACKUP_MAPPED_FOLDER/ca.pem

# Nom du folder backup dans container
BACKUP_FOLDER=$BACKUP_ROOT/$BACKUP_LEAF

IMAGE=mongo:6
COMMAND="mongodump -u admin -p $MONGO_PASSWORD  --host mongo --ssl --sslPEMKeyFile=$BACKUP_ROOT/mongo.key_cert --sslCAFile=$BACKUP_ROOT/ca.pem -o $BACKUP_FOLDER --oplog --gzip"

docker run -t --rm --network millegrille_net -v $BACKUP_MAPPED_FOLDER:$BACKUP_ROOT $IMAGE $COMMAND

rm $KEY_CERT_FILE

# chmod -R 750 "$BACKUP_MAPPED_FOLDER"
# sudo chown $USER:$USER
tar -cf $BACKUP_MAPPED_FOLDER/mongo_backup.tar $BACKUP_MAPPED_FOLDER/$BACKUP_LEAF

echo "Copy to fs1"
rsync --rsh "ssh -i /home/mathieu/.ssh/id_ed25519_backup" $BACKUP_MAPPED_FOLDER/mongo_backup.tar mginstance_prive1@fs1:backup_mongo

if [ $? -eq 0 ]; then
  echo -n "Backup complete avec succes "; date
else
  exit 2
fi

