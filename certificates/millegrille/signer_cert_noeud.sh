#!/usr/bin/env bash

SERVER=$1
NOM_MILLEGRILLE=$2
NOM_NOEUD=$3
DOMAIN_SUFFIX=$4
TYPE_NOEUD=$5

export CNF_FILE=openssl-millegrille.cnf

if [ -z $DOMAIN_SUFFIX ]; then
  echo "Il faut fournir les parametres suivants: server nom_millegrille nom_noeud domaine"
  exit 1
fi

HOSTNAME=`hostname --fqdn`
GIT_FOLDER=$HOME/git/MilleGrilles.consignation/certificates

source $GIT_FOLDER/fonctions_cert.sh

# Remote parameters
SCRIPT_CREATION=creer_cert_noeud.sh
if [ -n $TYPE_NOEUD ]; then
  if [ $TYPE_NOEUD = 'middleware' ]; then
    SCRIPT_CREATION=creer_cert_millegrille_middleware.sh
  fi
fi

NOM_NOEUD_COMPLET=$NOM_NOEUD.$DOMAIN_SUFFIX
export HOSTNAME NOM_MILLEGRILLE DOMAIN_SUFFIX NOM_NOEUD_COMPLET

# Creer et signer un nouveau certificat
preparer_creation_cert_noeud $SERVER $NOM_MILLEGRILLE $NOM_NOEUD $DOMAIN_SUFFIX $SCRIPT_CREATION
downloader_csr $SERVER noeud ${NOM_NOEUD_COMPLET}
signer_certificat \
  $HOSTNAME/requests/${NOM_NOEUD_COMPLET}.csr \
  $HOSTNAME/named_certs/${NOM_NOEUD_COMPLET}.cert.pem
concatener_chaine_noeud $HOSTNAME/named_certs ${NOM_NOEUD_COMPLET}.cert.pem
transmettre_certificat $SERVER $HOSTNAME/named_certs ${NOM_NOEUD_COMPLET}.cert.pem
