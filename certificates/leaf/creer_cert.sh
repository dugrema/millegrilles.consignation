#!/usr/bin/env bash

NOM_OU=$1

if [ -z $NOM_OU ]; then
  echo "Il faut fournir un nom pour le certificat"
fi

CNF_FILE=openssl-millegrille.cnf
PRIVATE_PATH=~/certificates/millegrilles/privkeys
KEY=$PRIVATE_PATH/${NOM_OU}.pem

openssl req \
        -config $CNF_FILE \
        -newkey rsa:8192 \
        -sha512 \
        -nodes \
        -out ${NOM_OU}_req.csr -outform PEM \
        -keyout $KEY -keyform PEM

# Creer backup de la cle
chmod 400 $KEY
cp $KEY $KEY.`date +%Y%m%d`

# Signer avec le certificat signing
