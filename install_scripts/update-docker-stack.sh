#!/usr/bin/env bash

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
echo "Domain suffix: $DOMAIN_SUFFIX"
source $MG_FOLDER_ETC/variables.txt

mettre_a_jour_template() {
  cd $MG_FOLDER_DOCKER_CONF

  export CERTS_DATE=`cat $CERT_PATH/${NOM_MILLEGRILLE}_middleware_latest.txt`
  export PASSWORDS_DATE=`cat $CERT_PATH/${NOM_MILLEGRILLE}_passwords_latest.txt`
  export WEB_DATE=`cat $CERT_PATH/${NOM_MILLEGRILLE}_web_latest.txt`
  export MG_FOLDER_NGINX_WWW_LOCAL MG_FOLDER_NGINX_WWW_PUBLIC
  export NOM_MILLEGRILLE=$NOM_MILLEGRILLE MG_NOM_MILLEGRILLE=$NOM_MILLEGRILLE
  export MG_MONGO_USER_MAITREDESCLES
  export URL_DOMAIN=$DOMAIN_SUFFIX

  cd $MG_FOLDER_DOCKER_CONF
  echo "Repertoire courant $PWD"
  envsubst < $MG_FOLDER_ETC/docker/template.env > $MG_FOLDER_DOCKER_CONF/$NOM_MILLEGRILLE.env

  source $NOM_MILLEGRILLE.env
  export $(cut -d= -f1 $NOM_MILLEGRILLE.env)
  export FICHIER_CONFIG=$MG_FOLDER_DOCKER_CONF/$NOM_MILLEGRILLE.$CURDATE_NOW.yml
  docker-compose config > $FICHIER_CONFIG
}

deployer() {
  echo "[INFO] Fichier de configuration de la stack genere, demarrage du deploiement"
  if [ -f $FICHIER_CONFIG ]; then
    sudo docker stack deploy -c $FICHIER_CONFIG millegrille-$NOM_MILLEGRILLE
  fi
}

sequence() {
  mettre_a_jour_template
  deployer
}

sequence
