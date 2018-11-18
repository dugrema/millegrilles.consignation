#!/bin/bash

# Importer le nom du repository, image et version
source image_info.txt
ARCH=`uname -m`

#docker run --entrypoint python3 $REPO/$NAME.$ARCH:$VERSION millegrilles/transaction/ConsignateurTransaction.py
docker run -e "MG_MQ_HOST=192.168.1.110" -e "MG_MONGO_HOST=192.168.1.110" $REPO/$NAME.$ARCH:$VERSION
