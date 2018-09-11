#!/bin/bash

REPO=repository.maple.mdugre.info:5000
NAME=mg_rabbitmq
VERSION=1.0

ARCH=`uname -m`
IMAGENAME="$NAME.$ARCH:$VERSION"

docker build -t $IMAGENAME .

if [ $? -eq "0" ]; then
  docker tag $IMAGENAME $REPO/$IMAGENAME
  docker tag $IMAGENAME $REPO/$NAME.$ARCH
else
  echo "Erreur dans la creation de l'image"
fi

