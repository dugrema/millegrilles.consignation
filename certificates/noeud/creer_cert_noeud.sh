#!/usr/bin/env bash

#GIT_CERT_FOLDER=$HOME/git/MilleGrilles.consignation/certificates

NOM_MILLEGRILLE=$1
NOM_NOEUD=$2
DOMAIN_SUFFIX=$3
if [ -z $DOMAIN_SUFFIX ]; then
  echo "Il faut fournir: NOM_MILLEGRILLE NOM_NOEUD DOMAIN_SUFFIX"
  exit 1
fi

NOM_NOEUD_COMPLET=$NOM_NOEUD.$DOMAIN_SUFFIX
export NOM_MILLEGRILLE NOM_NOEUD DOMAIN_SUFFIX NOM_NOEUD_COMPLET # Utilise par CNF

# Importer fonctions
source fonctions_creer_certs.sh
NOEUD_FOLDER=$GIT_CERT_FOLDER/noeud

# Executer code creation d'un nouveau certificat de MilleGrille
KEY=$PRIVATE_PATH/${NOM_NOEUD_COMPLET}.pem
CNF_FILE=openssl-millegrille-noeud.cnf

preparer_path
requete $CNF_FILE $NOM_NOEUD_COMPLET $KEY
