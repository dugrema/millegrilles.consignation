#!/bin/bash

NOMGRILLE=$1

if [ -z $NOMGRILLE ]; then
  echo "Donner le nom de la millegrille"
  exit -1
fi

echo "Creer reseau overlay millegrilles"
docker network create -d overlay --opt encrypted mg_net_$1

