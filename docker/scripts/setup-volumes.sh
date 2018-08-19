#!/bin/bash

VOLUMES=(`cat volumes.txt`)

echo "Preparation des volumes [${VOLUMES[*]}] dans docker"

for vol in ${VOLUMES[@]}; do
  docker volume create $vol
done

echo "Setup volumes complete"
