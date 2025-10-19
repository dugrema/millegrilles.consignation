#!/bin/env bash

MONGO_PASSWORD=`cat /var/opt/millegrilles/secrets/passwd.mongo.txt`

BACKUP_MAPPED_FOLDER="/home/mathieu/backup"
SECRETS=/var/opt/millegrilles/secrets
KEY_CERT_FILE="$BACKUP_MAPPED_FOLDER/mongo.key_cert"
DATE=`date +"%Y%m%d-%H%M"`
BACKUP_ROOT=/mnt/backup

cat /var/opt/millegrilles/secrets/pki.mongo.key > $KEY_CERT_FILE
cat /var/opt/millegrilles/secrets/pki.mongo.cert >> $KEY_CERT_FILE
cp /var/opt/millegrilles/configuration/pki.millegrille.cert $BACKUP_MAPPED_FOLDER/ca.pem

IMAGE=mongo:8
# COMMAND="mongodump -u admin -p $MONGO_PASSWORD  --host mongo --ssl --sslPEMKeyFile=$BACKUP_ROOT/mongo.key_cert --sslCAFile=$BACKUP_ROOT/ca.pem -o $BACKUP_FOLDER --oplog --gzip"
# COMMAND="bash"
COMMAND="mongosh -u admin -p $MONGO_PASSWORD  --host mongo --tls --tlsCertificateKeyFile=$BACKUP_ROOT/mongo.key_cert --tlsCAFile=$BACKUP_ROOT/ca.pem"

docker run -it --rm --network millegrille_net -v $BACKUP_MAPPED_FOLDER:$BACKUP_ROOT $IMAGE $COMMAND

rm $KEY_CERT_FILE

