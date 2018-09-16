#!/bin/bash

# Importer le nom du repository, image et version
source image_info.txt
ARCH=`uname -m`

docker run $REPO/$NAME.$ARCH:$VERSION

