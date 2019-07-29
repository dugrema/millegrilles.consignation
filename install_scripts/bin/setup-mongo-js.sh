#!/usr/bin/env bash

#DATEFICHIER=201907281628
#NOM_MILLEGRILLE=test
#MONGOHOST=THINK003

PKI=/opt/millegrilles/$NOM_MILLEGRILLE/pki
KEY_CERT=/tmp/ssl.key_cert
CA_FILE=/tmp/cafile.pem

# Preparer cles pour connexion
PASSWORD_MONGO=`cat $PKI/passwords/mongo.root.password`
cat $PKI/keys/${NOM_MILLEGRILLE}_middleware_${DATEFICHIER}.key.pem \
    $PKI/certs/${NOM_MILLEGRILLE}_middleware_${DATEFICHIER}.cert.pem \
    > $KEY_CERT
cat $PKI/certs/${NOM_MILLEGRILLE}_ssroot.cert.pem \
    $PKI/certs/${NOM_MILLEGRILLE}_millegrille.cert.pem \
    > $CA_FILE

SCRIPT_COMPTES=$PKI/passwords/mongo_createusers.js

mongo --host $MONGOHOST -u root \
      -p $PASSWORD_MONGO \
      --ssl --sslAllowInvalidCertificates --sslAllowInvalidHostnames \
      --sslCAFile $CA_FILE \
      --sslPEMKeyFile $KEY_CERT \
      /opt/millegrilles/etc/mongo_rsinit.js

sleep 10 # Attendre que MongoDB devienne primary

mongo --host $MONGOHOST -u root \
      -p $PASSWORD_MONGO \
      --ssl --sslAllowInvalidCertificates --sslAllowInvalidHostnames \
      --sslCAFile $CA_FILE \
      --sslPEMKeyFile $KEY_CERT \
      $PKI/passwords/mongo_createusers.js
