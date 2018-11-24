#!/bin/bash

if [ ! -f image_info.txt ]; then
  echo "Fichier image_info.txt n'est pas present"
  exit 1
fi

# Importer le nom du repository, image et version, architectures
source image_info.txt

# Fonction pour concatener la liste des architectures a batir pour le manifeste
faire_liste_arch () {
   LISTE_ARCH=""
   for arch_supportee in "${ARCH_SUPPORTEES[@]}"
   do
     VAL=" $REPO/$NAME.$arch_supportee:$VERSION"
     LISTE_ARCH="$LISTE_ARCH $VAL"
   done
}

if [ -z $REPO ]; then
  echo "Il manque REPO"
  exit 2
fi
if [ -z $NAME ]; then
  echo "Il manque NAME"
  exit 3
fi
if [ -z $BRANCH ]; then
  echo "Il manque REPO"
  exit 4
fi
if [ -z $BUILD ]; then
  echo "Il manque BUILD"
  exit 5
fi
if [ -z $ARCH_SUPPORTEES ]; then
  echo "Il manque ARCH_SUPPORTEES"
  exit 6
fi

IMAGENAME=$REPO/$NAME:$VERSION
faire_liste_arch

sudo docker manifest create --insecure $IMAGENAME $LISTE_ARCH

if [ $? -eq "0" ]; then
  echo "Manifest updated: $IMAGENAME"

  sudo docker manifest push --purge $IMAGENAME
else
  echo "Erreur de creation du manifeste: $IMAGENAME"
fi

