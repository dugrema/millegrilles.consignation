#!/usr/bin/env bash
SECURE_PATH=~/certificates/millegrilles
PRIVATE_PATH=$SECURE_PATH/privkeys
CERT_PATH=$SECURE_PATH/certs

preparer_path() {
  mkdir -p $PRIVATE_PATH
  mkdir -p $CERT_PATH
  chmod 755 $SECURE_PATH
  chmod 700 $PRIVATE_PATH
}

requete() {
  CNF_FILE=$1
  FQDN_MILLEGRILLE=$2
  KEY=$3

  DATE=`date +%Y%m%d`

  openssl req \
          -config $CNF_FILE \
          -newkey rsa \
          -sha512 \
          -out millegrille_${FQDN_MILLEGRILLE}.csr -outform PEM \
          -keyout $KEY -keyform PEM

  if [ $? -ne 0 ]; then
    echo "Erreur creation certificat"
    exit 2
  fi

  # Creer backup de la cle
  chmod 400 $KEY
  cp $KEY $KEY.$DATE
}
