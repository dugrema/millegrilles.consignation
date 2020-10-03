#!/usr/bin/env bash

REP_CERTS=$APP_BUNDLE_FOLDER/certs
REP_KEYS=$APP_BUNDLE_FOLDER/keys

if [ ! -z $MG_CERT ]; then ln -sf $MG_CERT $REP_CERTS/cert.pem; fi
if [ ! -z $WEB_CERT ]; then ln -sf $WEB_CERT $REP_CERTS/webcert.pem; fi
if [ ! -z $MG_KEY ]; then ln -sf $MG_KEY $REP_KEYS/key.pem; fi
if [ ! -z $WEB_KEY ]; then ln -sf $WEB_KEY $REP_KEYS/webkey.pem; fi

if [ ! -z $MG_CA ]; then
  ln -sf $MG_CA $REP_CERTS/calist.cert.pem
else
  echo "Batir la chaine de certificats CA a partir de cert.pem"
  # Recuperer les certificats CA, enlever le premier de la liste qui est le
  # cert local.
  awk -v fichier_cert=$REP_CERTS/calist.cert.pem 'BEGIN {c=0;} /BEGIN CERT/{c++} { if(c > 1) print > fichier_cert;}' < $REP_CERTS/cert.pem
fi

# Verification de quel fichier de configuration on utilise
if [ ! -z $CONFIG_FILE ]; then
  echo "[INFO] Remplacement du fichier rabbitmq.config par $CONFIG_FILE"
  cp $CONFIG_FILE /etc/rabbitmq/rabbitmq.config
fi

echo "Fichier configuration"
cat /etc/rabbitmq/rabbitmq.config
echo "---------------------"

cd /

echo "Demarrage rabbitmq-server"
docker-entrypoint.sh rabbitmq-server
