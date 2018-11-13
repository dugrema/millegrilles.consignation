!/bin/bash

# Importer le nom du repository, image et version
source image_info.txt

ARCH=`uname -m`
IMAGENAME="$NAME.$ARCH:$VERSION"

docker build -t $IMAGENAME .

if [ $? -eq "0" ]; then
  docker tag $IMAGENAME $REPO/$IMAGENAME
  docker tag $IMAGENAME $REPO/$NAME.$ARCH:latest

  echo "Image prete: $REPO/$IMAGENAME"
  docker push $REPO/$IMAGENAME
  echo "Push complete $REPO/$IMAGENAME"

else
  echo "Erreur dans la creation de l'image"
fi

