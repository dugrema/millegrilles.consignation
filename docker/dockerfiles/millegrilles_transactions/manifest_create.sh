#!/bin/bash

REPO=repository.maple.mdugre.info:5000
NAME=mg_transactions
VERSION=1.0

IMAGENAME=$REPO/$NAME:$VERSION

sudo docker manifest create --insecure $IMAGENAME \
  $REPO/$NAME.x86_64:$VERSION\
  $REPO/$NAME.armv7l:$VERSION

if [ $? -eq "0" ]; then
  echo "Manifest updated: $IMAGENAME"

  sudo docker manifest push --purge $IMAGENAME
else
  echo "Erreur de creation du manifeste: $IMAGENAME"
fi

