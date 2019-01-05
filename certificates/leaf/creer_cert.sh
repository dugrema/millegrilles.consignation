#!/usr/bin/env bash

NOM_OU=$1

if [ -z $NOM_OU ]; then
  echo "Il faut fournir un nom pour le certificat"
  exit 1
fi

export NOM_OU

CNF_FILE=openssl-millegrille.cnf
SECURE_PATH=~/certificates/millegrilles
PRIVATE_PATH=$SECURE_PATH/privkeys
CERT_PATH=$SECURE_PATH/certs
KEY=$PRIVATE_PATH/${NOM_OU}.pem

preparer_path() {
  mkdir -p $PRIVATE_PATH
  mkdir -p $CERT_PATH
  chmod 755 $SECURE_PATH
  chmod 700 $PRIVATE_PATH
}

requete() {
  CNF_FILE=$1
  NOM_OU=$2
  KEY=$3

  openssl req \
          -config $CNF_FILE \
          -sha512 \
          -nodes \
          -out ${NOM_OU}.csr -outform PEM \
          -keyout $KEY -keyform PEM

  if [ $? -ne 0 ]; then
    echo "Erreur creation certificat"
    exit 2
  fi

  # Creer backup de la cle
  chmod 400 $KEY
  cp $KEY $KEY.`date +%Y%m%d`
}

preparer_path
requete $CNF_FILE $NOM_OU $KEY
