#!/usr/bin/env bash

NOM_FICHIER=$1

export CNF_FILE=openssl-millegrille.cnf

if [ -z $NOM_FICHIER ]; then
  echo "Il faut fournir les parametres suivants: NOM_FICHIER"
  exit 1
fi

HOSTNAME=`hostname --fqdn`
GIT_FOLDER=$HOME/git/MilleGrilles.consignation/certificates

source $GIT_FOLDER/fonctions_cert.sh

export HOSTNAME
export NOM_MILLEGRILLE=NA DOMAIN_SUFFIX=NA

# Creer et signer un nouveau certificat
signer_certificat \
  $HOSTNAME/requests/${NOM_FICHIER}.csr \
  $HOSTNAME/named_certs/${NOM_FICHIER}.cert.pem
concatener_chaine_noeud $HOSTNAME/named_certs ${NOM_FICHIER}.cert.pem
