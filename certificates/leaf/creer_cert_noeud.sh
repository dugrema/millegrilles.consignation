#!/usr/bin/env bash

NOM_OU=$1
if [ -z $NOM_OU ]; then
  echo "Il faut fournir un nom pour le noeud"
  exit 1
fi
export NOM_OU  # Utilise par CNF

# Importer fonctions
source fonctions_creer_certs.sh

# Executer code creation d'un nouveau certificat de MilleGrille
KEY=$PRIVATE_PATH/${NOM_OU}.pem
CNF_FILE=openssl-millegrille-noeud.cnf

preparer_path
requete $CNF_FILE $NOM_OU $KEY
