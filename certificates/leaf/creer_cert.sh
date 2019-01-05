#!/usr/bin/env bash

NOM_OU=$1

if [ -z $NOM_OU ]; then
  echo "Il faut fournir un nom pour le certificat"
  exit 1
fi

CNF_FILE=openssl-millegrille.cnf
SECURE_PATH=~/certificates/millegrilles
PRIVATE_PATH=$SECURE_PATH/privkeys
KEY=$PRIVATE_PATH/${NOM_OU}.pem

mkdir -p $PRIVATE_PATH
mkdir -p $CERT_PATH

requete() {
  CNF_FILE=$1
  NOM_OU=$2
  KEY=$3

  openssl req \
          -config $CNF_FILE \
          -newkey rsa:8192 \
          -sha512 \
          -nodes \
          -out ${NOM_OU}.csr -outform PEM \
          -keyout $KEY -keyform PEM

  # Creer backup de la cle
  chmod 400 $KEY
  cp $KEY $KEY.`date +%Y%m%d`
}

requete $CNF_FILE $NOM_OU $KEY

