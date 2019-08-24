#!/usr/bin/env bash

# Parametres obligatoires
if [ -z $NOM_MILLEGRILLE ] || [ -z $DOMAIN_SUFFIX ]; then
  echo "Les parametres NOM_MILLEGRILLE et DOMAIN_SUFFIX doivent etre definis globalement"
  exit 1
fi

# Parametres optionnel
if [ -z $CURDATE ]; then
  CURDATE=`date +%Y%m%d%H%M`
fi

# Importer les variables et fonctions
source /opt/millegrilles/etc/variables.txt
source $MG_FOLDER_BIN/setup-certs-fonctions.sh

# Sequence
sequence_chargement() {
  verifier_acces_docker
  if [ $? != 0 ]; then
    exit $?
  fi

  # Creer le noeud middleware
  echo -e "\n*****\nGenerer un certificat de MaitreDesCles"

  creer_cert_maitredescles

  if [ $? != 0 ]; then
    exit $?
  fi
}

# Executer
sequence_chargement
