#!/bin/bash

VOLUMES=(`cat volumes.txt`)

echo "Preparation des volumes [${VOLUMES[*]}] dans docker"

ERREURS=0
REUSSIS=0

for vol in ${VOLUMES[@]}; do
  docker volume create $vol
  if [ $? -eq "0" ]; then
    ((REUSSIS++))  # Compter le nombre d'echecs
  else
    ((ERREURS++))
  fi
done

echo "Setup $REUSSIS volumes complete, $ERREURS erreurs"
