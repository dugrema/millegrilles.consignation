#!/bin/bash

DATE=`date +%Y%m%d`
CERT_FOLDER=/etc/letsencrypt/live/www.pivoine.mdugre.info
PREFIX_CLE=ssl.pivoine.millegrilles

FICHIERS=( cert chain fullchain privkey )

function ajouter_secret() {
  CLE=$PREFIX_CLE.$1.$DATE
  sudo cat $CERT_FOLDER/$1.pem | docker secret create $CLE -
}

for FICHIER in ${FICHIERS[@]}; do
  ajouter_secret $FICHIER
done

sudo cat $CERT_FOLDER/privkey.pem $CERT_FOLDER/fullchain.pem | docker secret create  $PREFIX_CLE.key_cert.$DATE -

echo "Certificats ajoutes a docker pour $PREFIX_CLE date $DATE"
