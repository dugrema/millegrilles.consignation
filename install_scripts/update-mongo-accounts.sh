#!/usr/bin/env bash

if [ -z $NOM_MILLEGRILLE ]; then
  echo "Il faut fournir le nom de la millegrille"
fi

source /opt/millegrilles/etc/variables.txt

inserer_comptes_mongo() {
  # Fabrique un mapping vers le reseau overlay mg_net (permet de trouver le
  # serveur mongo), de /opt/millgrilles/bin et /opt/millegrilles/NOM_MILLEGRILLE.
  # Execute le script setup-mongo-js.sh qui va executer le script avec
  # mots de passes dans /opt/millegrilles/NOM_MILLEGRILLE/mounts/mongo-shared.

  sudo docker container run --rm -it \
         -e MONGOHOST=mongo --network $NET_NAME \
         -e NOM_MILLEGRILLE=$NOM_MILLEGRILLE \
         -v $MG_FOLDER_BIN:$MG_FOLDER_BIN \
         -v $MG_FOLDER_MILLEGRILLE:$MG_FOLDER_MILLEGRILLE \
         mongo:4.0 \
         $MG_FOLDER_BIN/setup-mongo-js.sh
}

inserer_comptes_mongo
