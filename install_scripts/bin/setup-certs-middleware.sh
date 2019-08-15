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
  echo -e "\n*****\nGenerer un certificat de noeud Middleware"

  creer_cert_middleware

  if [ $? != 0 ]; then
    exit $?
  fi

  importer_dans_docker

  # Verifier si on import les certificats internes ou si les certs
  # let's encrypt sont disponibles
  if [ ! -d $MG_FOLDER_LETSENCRYPT/live ]; then
    echo "[INFO] Certificats Let's Encrypt non disponibles. On utiliser les certs self-signed interne pour le web."
    # Importer les certificats ss pour remplacer les publics
    importer_public_ss
  else
    importer_public_letsencrypt
  fi
}

# Executer
sequence_chargement
