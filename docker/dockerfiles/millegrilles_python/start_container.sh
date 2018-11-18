#!/bin/bash

# Importer le nom du repository, image et version
source image_info.txt
ARCH=`uname -m`

#docker run --entrypoint python3 $REPO/$NAME.$ARCH:$VERSION millegrilles/transaction/ConsignateurTransaction.py
docker run $REPO/$NAME.$ARCH:$VERSION
