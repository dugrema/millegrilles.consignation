#!/usr/bin/env bash

NOM_OU=$1

if [ -z $NOM_OU ]; then
  echo "Le nom du fichier (prefixe) doit etre fourni"
  exit 1
fi

CNF_FILE=openssl-millegrilles-signing.cnf
PRIVATE_PATH=~/certificates/millegrilles/privkeys
DB_PATH=db
REQUEST_PATH=$DB_PATH/requests
CERT_PATH=$DB_PATH/named_certs

if [ -z $CERT_OUTPUT_FILE ]; then
  echo "CERT_OUTPUT_FILE file doit etre fourni"
  exit 1
fi

if [ ! -f $REQUEST_FILE ]; then
  echo "Request file pas accessible: $REQUEST_FILE"
  exit 2
fi

openssl ca -config $CNF_FILE \
        -policy signing_policy \
        -extensions signing_req \
        -out $CERT_PATH/${CERT_OUTPUT_FILE}.cert.pem \
        -infiles $REQUEST_PATH/${REQUEST_FILE}.csr
