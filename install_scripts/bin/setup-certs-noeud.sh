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
source setup-certs-fonctions.sh

# Sequence
sequence_chargement() {
  # Creer le certificat noeud
  echo -e "\n*****\nGenerer un certificat de noeud"

  SUFFIX_NOMCLE=middleware \
  CNF_FILE=$ETC_FOLDER/openssl-millegrille-noeud.cnf \
  creer_cert_noeud

  if [ $? != 0 ]; then
    exit $?
  fi
}

# Executer
sequence_chargement
