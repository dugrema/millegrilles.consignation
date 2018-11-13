#!/bin/bash

# Importer le nom du repository, image et version
source image_info.txt

ARCH=`uname -m`
IMAGENAME="$NAME.$ARCH:$VERSION"

# Copier les fichiers source dans un repertoire temporaire pour
# les inclure a l'image.
GIT_NAME=MilleGrilles.consignation.python
GIT_PATH=ssh://repository.maple.mdugre.info/var/lib/git/$GIT_NAME.git
SRC_FOLDER=tmp_src
GIT_FOLDER=$SRC_FOLDER/$GIT_NAME

mkdir $SRC_FOLDER
git -C $SRC_FOLDER clone $GIT_PATH
if [ $? -ne "0" ]; then
  echo "Erreur extraction code via git"
  exit -1
fi

rm -rf $GIT_FOLDER/.git
ln -s $GIT_FOLDER src

docker build -t $IMAGENAME .

if [ $? -eq "0" ]; then
  docker tag $IMAGENAME $REPO/$IMAGENAME
  docker tag $IMAGENAME $REPO/$NAME.$ARCH

  echo "Image prete: $REPO/$IMAGENAME"
  docker push $REPO/$IMAGENAME
  echo "Push complete $REPO/$IMAGENAME"
else
  echo "Erreur dans la creation de l'image"
fi

# Cleanup, effacer les repertoires de travail
rm -rf $SRC_FOLDER src

