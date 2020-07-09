#!/bin/bash

FICHIERS=`find /run/secrets/*`
for SECRET in $FICHIERS; do
  NOM_SECRET=$(echo $SECRET | cut -f4 -d'/')
  echo $NOM_SECRET = $SECRET
  export $NOM_SECRET=`cat $SECRET`
done
