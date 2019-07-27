#!/bin/bash
if [ ! -z $1 ]; then
  NODENAME=$1
else
  NODENAME=`hostname`  # Utiliser node local par defaut
fi
echo "Node name: $NODENAME"

# Creer labels pour les machines de la MilleGrille
# Le premier element de la liste est le label, les autres sont les nodes
LABEL_NETZONE_PRIVATE=( "netzone.private=true" $NODENAME)
LABEL_NETZONE_PUBLIC=( "netzone.public=true" $NODENAME )
LABEL_MILLEGRILLES_DATABASE=( "millegrilles.database=true" $NODENAME )
LABEL_MILLEGRILLES_MQ=( "millegrilles.mq=true" $NODENAME )
LABEL_MILLEGRILLES_CONSOLES=( "millegrilles.consoles=true" $NODENAME )

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
