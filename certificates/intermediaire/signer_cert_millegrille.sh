#!/usr/bin/env bash

SERVER=$1
NOM_MILLEGRILLE=$2
DOMAIN_SUFFIX=$3

export CNF_FILE=openssl-intermediaire.cnf

if [ -z $DOMAIN_SUFFIX ]; then
  echo "Il faut fournir les parametres suivants: server nom_millegrille domaine"
  exit 1
fi

# Remote parameters
SCRIPT_CREATION=creer_cert_millegrille.sh
HOSTNAME=`hostname --fqdn`
GIT_FOLDER=$HOME/git/MilleGrilles.consignation/certificates

source $GIT_FOLDER/fonctions_cert.sh

export HOSTNAME NOM_MILLEGRILLE DOMAIN_SUFFIX

# Creer et signer un nouveau certificat
# preparer_creation_cert_millegrille $SERVER $NOM_MILLEGRILLE $DOMAIN_SUFFIX
# downloader_csr $SERVER millegrille millegrille_${NOM_MILLEGRILLE}.${DOMAIN_SUFFIX}
signer_certificat \
  $HOSTNAME/requests/millegrille_${NOM_MILLEGRILLE}.${DOMAIN_SUFFIX}.csr \
  $HOSTNAME/named_certs/millegrille_${NOM_MILLEGRILLE}.${DOMAIN_SUFFIX}.cert.pem
concatener_chaine $HOSTNAME/named_certs millegrille_${NOM_MILLEGRILLE}.${DOMAIN_SUFFIX}.cert.pem
transmettre_certificat $SERVER $HOSTNAME/named_certs millegrille_${NOM_MILLEGRILLE}.${DOMAIN_SUFFIX}.cert.pem
