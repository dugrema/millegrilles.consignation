#!/usr/bin/env bash

DOCKER_COMPOSE=/usr/local/bin/docker-compose

if [ -z $1 ]; then
  echo "Il faut fournir le nom de l'environnement"
  exit 1
fi

ENV_NAME=$1
if [ ! -f $ENV_NAME.env ]; then
  echo "Le fichier $ENV_NAME.env n'existe pas"
  exit 2
fi


# Exporter les variables du fichier d'environnement
source $ENV_NAME.env
export $(cut -d= -f1 $ENV_NAME.env)

$DOCKER_COMPOSE config > $ENV_NAME.yml

echo -en "\nFichier $ENV_NAME.yml cree."
exit 0
