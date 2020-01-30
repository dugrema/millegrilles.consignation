#!/bin/bash
source image_info.txt
ARCH=`uname -m`

docker pull linuxserver/transmission:$BRANCH

IMAGE_LOCALE=docker.maceroc.com/transmission:${ARCH}_${BRANCH}
echo "Preparation $IMAGE_LOCALE"

docker tag linuxserver/transmission:$BRANCH $IMAGE_LOCALE
docker push $IMAGE_LOCALE
