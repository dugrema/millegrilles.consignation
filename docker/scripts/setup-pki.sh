#!/usr/bin/env bash

PKI_FOLDER=/etc/opt/millegrilles/pivoine/pki
# CERT_FOLDER=$PKI_FOLDER
KEY_FOLDER=$PKI_FOLDER/keys

# Ce script utilise des links existants pour importer les cles dans docker

DATE=`date +%Y%m%d`

CLES_SSL=( \
  pki.millegrilles.ssl.cert \
  pki.millegrilles.ssl.key \
  pki.millegrilles.ssl.key_cert \
  pki.millegrilles.ssl.CAchain \
)
CLES_WEB=( \
  pki.millegrilles.web.cert \
  pki.millegrilles.web.chain \
  pki.millegrilles.web.fullchain \
  pki.millegrilles.web.key \
)

CLES=( "${CLES_SSL[@]}" )  # Liste SSL seulement
#CLES=( "${CLES_WEB[@]}" )  # Liste web seulement
#CLES=( "${CLES_SSL[@]}" "${CLES_WEB[@]}" )  # Liste complete

# Verifier que tous les fichiers de cles peuvent etre lus
for CLE in ${CLES[@]}; do
  if [ ! -r $PKI_FOLDER/$CLE ]; then
    echo "Erreur access $PKI_FOLDER/$CLE (not readable)"
    exit 1
  fi
done

# Ajouter les cles dans docker
for CLE in ${CLES[@]}; do
  echo "Ajout $CLE.$DATE"
  docker secret create $CLE.$DATE $PKI_FOLDER/$CLE

  if [ $? -ne 0 ]; then
    echo "Erreur ajout $PKI_FOLDER/$CLE dans docker"
    exit 2
  fi
done

echo "Ajout des cles complete avec succes"
