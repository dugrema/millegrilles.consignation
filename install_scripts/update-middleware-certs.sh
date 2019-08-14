#!/usr/bin/env bash

# Ce script sert a mettre a jour le certificat de middleware.
# Le plus recent certificat de millegrille est utilise. Tous les
# certificats associes sont reimportes dans docker.
set -e  # Quitter pour toute erreur

if [ -z $1 ]; then
  echo "Il faut fournir les parametres suivants:"
  echo "  1-NOM_MILLEGRILLE"
  exit 1
fi

MG_FOLDER_ROOT=/opt/millegrilles
MG_FOLDER_BIN=$MG_FOLDER_ROOT/bin
MG_FOLDER_ETC=$MG_FOLDER_ROOT/etc

# Charger le DOMAIN_SUFFIX, utilise pour les certificats
export NOM_MILLEGRILLE=$1
source $MG_FOLDER_ETC/${NOM_MILLEGRILLE}.conf
export DOMAIN_SUFFIX
source $MG_FOLDER_BIN/setup-certs-fonctions.sh

cd $MG_FOLDER_BIN
./setup-certs-middleware.sh
