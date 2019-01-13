#!/usr/bin/env bash

GIT_CERT_FOLDER=$HOME/git/MilleGrilles.consignation/certificates
MG_FOLDER=$GIT_CERT_FOLDER/millegrille

NOM_MILLEGRILLE=$1
if [ -z $NOM_MILLEGRILLE ]; then
  echo "Il faut fournir un nom de la MilleGrille pour le certificat"
  exit 1
fi
export NOM_MILLEGRILLE  # Utilise par CNF

DOMAIN_SUFFIX=$2
if [ -z $DOMAIN_SUFFIX ]; then
  echo "Il faut fournir le suffixe du domaine de la MilleGrille"
  exit 1
fi
export DOMAIN_SUFFIX  # Utilise par CNF

# Importer fonctions
source $MG_FOLDER/fonctions_creer_certs.sh

# Executer code creation d'un nouveau certificat de MilleGrille
KEY=$PRIVATE_PATH/millegrille_${NOM_MILLEGRILLE}.${DOMAIN_SUFFIX}.pem
CNF_FILE=$MG_FOLDER/openssl-millegrille.cnf
HOSTNAME=`hostname --fqdn`  # Requis pour que le fichier CNF fonctionne
export HOSTNAME

preparer_path
requete $CNF_FILE $NOM_MILLEGRILLE $NOM_MILLEGRILLE.$DOMAIN_SUFFIX $KEY
