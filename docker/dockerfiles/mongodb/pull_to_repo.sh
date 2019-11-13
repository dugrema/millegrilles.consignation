#!/usr/bin/env bash

# Aucuns changements a faire pour l'image
# On fait juste la copier dans le repository et batir un nouveau manifest

source image_info.txt

ARCH=`uname -m`

LOCAL_REPO_IMAGE=$REPO/${NAME}:${ARCH}_${VERSION}
echo $LOCAL_REPO_IMAGE

docker pull $NAME:$VERSION
docker tag $NAME:$VERSION $LOCAL_REPO_IMAGE

docker push $LOCAL_REPO_IMAGE
