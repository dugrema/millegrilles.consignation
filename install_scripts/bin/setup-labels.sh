#!/bin/bash

# Creer labels pour les machines de la MilleGrille
# Le premier element de la liste est le label, les autres sont les nodes
LABEL_NETZONE_PRIVATE=( "netzone.private=true" infraserv1 pi-host1 garage cuisine )
LABEL_NETZONE_PUBLIC=( "netzone.public=true" public1 )
LABEL_MILLEGRILLES_DATABASE=( "millegrilles.database=true" infraserv1 )
LABEL_MILLEGRILLES_MQ=( "millegrilles.mq=true" infraserv1 )
LABEL_MILLEGRILLES_CONSOLES=( "millegrilles.consoles=true" infraserv1 )

label_add () {
  LABEL=$1  # Premier parametre est le label
  NODES=(${@:2})  # Tous les autres parametres sont des nodes
  echo Label: $LABEL
  echo Nodes: ${NODES[*]}

  for node in ${NODES[*]}; do
    #docker node update --label-add $LABEL=true $node
    echo "docker node update --label-add $LABEL $node"
  done
  echo ---
}

# Verifier qu'on est sur un manager
docker node ls > /dev/null 2> /dev/null
if [ $? -ne "0" ]; then
  echo "On ne semble pas etre sur un manager. Echec."
  exit -1
fi

# Ajouter les labels sur les nodes
label_add ${LABEL_NETZONE_PRIVATE[*]}
label_add ${LABEL_NETZONE_PUBLIC[*]}
label_add ${LABEL_MILLEGRILLES_DATABASE[*]}
label_add ${LABEL_MILLEGRILLES_MQ[*]}
label_add ${LABEL_MILLEGRILLES_CONSOLES[*]}

