#!/bin/bash

if [ -z $2 ]; then
  echo "Usage: fournir NOM_MILLEGRILLE (1) et WEB_DOMAIN (2) en parametre"
  exit 1
fi

NOM_MILLEGRILLE=$1
WEB_DOMAIN=$2

DATE=`date +%Y%m%d%H%M`
# ACME_CERT_FOLDER=~/.acme.sh/www.maple.maceroc.com

CLE=$NOM_MILLEGRILLE.pki.millegrilles.web.key.$DATE
CLE_FILE=~/.acme.sh/$ACME_CERT_FOLDER/$WEB_DOMAIN/$WEB_DOMAIN.key
echo "Creation cle $CLE a partir de $CLE_FILE"
cat $CLE_FILE | docker secret create $CLE -

FULLCHAIN=$NOM_MILLEGRILLE.pki.millegrilles.web.fullchain.$DATE
FULLCHAIN_FILE=~/.acme.sh/$ACME_CERT_FOLDER/$WEB_DOMAIN/fullchain.cer
echo "Creation cle $FULLCHAIN a partir de $FULLCHAIN_FILE"
cat $FULLCHAIN_FILE | docker secret create $FULLCHAIN -

echo "Certificats ajoutes a docker pour $PREFIX_CLE date $DATE"
