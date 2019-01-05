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

# Creer et signer un nouveau certificat
preparer_creation_cert_millegrille $SERVER $NOM_OU $DOMAIN_SUFFIX
downloader_csr $SERVER $NOM_OU
signer_certificat $NOM_OU db/requests/$NOM_OU.csr db/named_certs/$NOM_OU.cert.pem
transmettre_certificat $SERVER db/named_certs/$NOM_OU.cert.pem
