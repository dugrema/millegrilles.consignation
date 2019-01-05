#!/usr/bin/env bash

source fonctions_cert.sh

NOM_OU=$1

if [ -z $NOM_OU ]; then
  echo "Il faut fournir les parametres suivants: server nom_noeud"
fi

# Creer et signer un nouveau certificat
signer_certificat $NOM_OU db/requests/$NOM_OU.csr db/named_certs/$NOM_OU.cert.pem
concatener_chaine db/named_certs/$NOM_OU.cert.pem
