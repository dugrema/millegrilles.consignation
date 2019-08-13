#!/usr/bin/env bash

# Ce script permet d'executer des actions avec un client mongo
# pour initialiser un serveur deja actif avec docker.

#DATEFICHIER=201907281628
#NOM_MILLEGRILLE=test
#MONGOHOST=THINK003

if [ -z $MONGOHOST ] || [ -z $NOM_MILLEGRILLE ]; then
  echo "[FAIL] Il faut fournir MONGOHOST et NOM_MILLEGRILLE"
  exit 1
fi

MG_FOLDER_ROOT=/opt/millegrilles
PKI=$MG_FOLDER_ROOT/$NOM_MILLEGRILLE/pki
CA_FILE=$PKI/certs/${NOM_MILLEGRILLE}_CA_chain.cert.pem
KEY_CERT=/tmp/ssl.key_cert

# Preparer cles pour connexion avec le client mongo
PASSWORD_MONGO=`cat $PKI/passwords/mongo.root.password`
cat $PKI/keys/${NOM_MILLEGRILLE}_middleware.key.pem \
    $PKI/certs/${NOM_MILLEGRILLE}_middleware.cert.pem \
    > $KEY_CERT

echo "[INFO] Execution de mongo_rsinit.js"

mongo --host $MONGOHOST -u root \
      -p $PASSWORD_MONGO \
      --ssl --sslAllowInvalidCertificates --sslAllowInvalidHostnames \
      --sslCAFile $CA_FILE \
      --sslPEMKeyFile $KEY_CERT \
      $MG_FOLDER_ROOT/bin/mongo_rsinit.js

echo "[INFO] Attente du serveur, doit devenir PRIMARY"

sleep 10 # Attendre que MongoDB devienne primary

SCRIPT_COMPTES=$MG_FOLDER_ROOT/$NOM_MILLEGRILLE/mounts/mongo-shared/mongo_createusers.js
NOM_DATABASE=mg-$NOM_MILLEGRILLE

echo "[INFO] Ajout des comptes de services"

mongo -u root -p $PASSWORD_MONGO \
      --authenticationDatabase admin \
      --ssl --sslAllowInvalidCertificates --sslAllowInvalidHostnames \
      --sslCAFile $CA_FILE --sslPEMKeyFile $KEY_CERT \
      $MONGOHOST/$NOM_DATABASE \
      $SCRIPT_COMPTES

echo "[OK] Configuration de mongo completee avec succes"
