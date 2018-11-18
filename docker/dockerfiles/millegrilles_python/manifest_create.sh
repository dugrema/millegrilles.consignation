#!/bin/bash

# Importer le nom du repository, image et version
source image_info.txt

IMAGENAME=$REPO/$NAME:$VERSION

sudo docker manifest create --insecure $IMAGENAME \
  $REPO/$NAME.x86_64:$VERSION #\
#  $REPO/$NAME.armv7l:$VERSION

if [ $? -eq "0" ]; then
  echo "Manifest updated: $IMAGENAME"

  sudo docker manifest push --purge $IMAGENAME
else
  echo "Erreur de creation du manifeste: $IMAGENAME"
fi

