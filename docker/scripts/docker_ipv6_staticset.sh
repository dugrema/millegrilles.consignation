#!/bin/bash

# Instructions: pour installer ce script
# 1. Copier docker_ipv6_staticset.sh vers /usr/local/bin.
# 2. Copier docker_ipv6_dictionary.txt vers /etc/docker
# 3. Ajouter le script au crontab de root.

FICHIER_CONFIGURATION="/etc/docker/docker_ipv6_dictionary.txt"

#INTERFACE=eth0
#NOM_RESEAU=ipv6_sample2
#declare -A CONTAINER_IPS
#CONTAINER_IPS=( \
#["httpd"]="::1" \
#["https"]="::2" \
#)

# L'override du fichier de configuration se fait pas le parametre $1
if [ ! -z "$1" ]; then
  FICHIER_CONFIGURATION=$1
fi

source $FICHIER_CONFIGURATION

if [ "$?" -ne 0 ]; then
  echo "Le fichier de configuration est introuvable"
  exit -1
fi

for CONTAINER_NAME in "${!CONTAINER_IPS[@]}";
do

  #echo "Verification de $CONTAINER_NAME"
  CONTAINER_ID=`docker container ls -f "name=$CONTAINER_NAME" -q`

  if [ ! -z "$CONTAINER_ID" ]; then
    #echo "Container ID='$CONTAINER_ID'. Verifier reseau. "  

    RESULTAT=`docker network inspect $NOM_RESEAU | grep $CONTAINER_ID`
    if [ "$?" -eq 0 ]; then
      #echo "Le container $CONTAINER_NAME/$CONTAINER_ID est deploye. Ok, rien a faire."
      true # Filler, rien a faire
    else
      IP=${CONTAINER_IPS[$CONTAINER_NAME]}
      #echo "Le container $CONTAINER_NAME/$CONTAINER_ID n'est pas deploye sur $NOM_RESEAU. Utiliser IPv6: $IP, exposer par proxy NDP sur $INTERFACE"

      docker network connect --ip6 $IP $NOM_RESEAU $CONTAINER_ID
      if [ "$?" -eq 0 ]; then
        #echo "Ajout neigh proxy pour $IP sur $INTERFACE"
        sudo ip -6 neigh add proxy $IP dev $INTERFACE
        if [ "$?" -ne 0 ]; then
          echo "ERREUR: Ajout du neigh proxy pour $IP sur $INTERFACE n'a pas fonctionne"
        fi
      else
        echo "ERREUR: Ajout du container container $CONTAINER_NAME/$CONTAINER_ID sur $NOM_RESEAU ne fonctionne pas. (IPv6: $IP)"
      fi
    fi

  else
    #echo "Container $CONTAINER_NAME non deploye. Rien a faire."
    true # Filler, rien a faire
  fi

done
