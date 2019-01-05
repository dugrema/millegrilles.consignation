#!/usr/bin/env bash

source fonctions_cert.sh

SERVER=$1
NOM_OU=$2
DOMAIN_SUFFIX=$3

# Remote parameters
SCRIPT_CREATION=creer_cert_millegrille.sh

if [ -z $DOMAIN_SUFFIX ]; then
  echo "Il faut fournir les parametres suivants: server nom_millegrille domaine"
fi

preparer_creation() {
  SERVER=$1
  NOM_OU=$2
  DOMAIN_SUFFIX=$3

  # Uploader le script et l'executer
  ssh $SERVER \
    cd $GIT_SCRIPT \;\
    git pull \;\
    cd $SCRIPT_PATH \;\
    ./$SCRIPT_CREATION $NOM_OU $DOMAIN_SUFFIX

  if [ $? -ne 0 ]; then
    echo "Erreur de preparation de la requete de certificat"
    exit 1
  fi
}

# Creer et signer un nouveau certificat
preparer_creation $SERVER $NOM_OU
#downloader_csr $SERVER $NOM_OU
#signer_certificat $NOM_OU db/requests/$NOM_OU.csr db/named_certs/$NOM_OU.cert.pem
#transmettre_certificat $SERVER db/named_certs/$NOM_OU.cert.pem
