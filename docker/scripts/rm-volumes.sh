#!/bin/bash

VOLUMES=(`cat volumes.txt`)

echo "Suppression des volumes [${VOLUMES[*]}] dans docker"

for vol in ${VOLUMES[@]}; do
  docker volume remove $vol
done

echo "Remove volumes complete"
