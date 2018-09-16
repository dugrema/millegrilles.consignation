#!/bin/bash

# Importer le nom du repository, image et version
source image_info.txt

ARCH=`uname -m`
IMAGENAME="$NAME.$ARCH:$VERSION"

# Copier les fichiers source dans un repertoire temporaire pour
# les inclure a l'image.
GIT_NAME=MilleGrilles.consignation.python
GIT_FOLDER=~/git/$GIT_NAME
git -C $GIT_FOLDER pull

mkdir src
cp $GIT_FOLDER/requirements.txt src/
cp -r $GIT_FOLDER/millegrilles/ src/

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
rm -rf src
