#!/bin/bash

# Importer le nom du repository, image et version
source image_info.txt
ARCH=`uname -m`

# On va executer l'orienteur de transaction plutot que le consignateur de transaction

docker run $REPO/$NAME.$ARCH:$VERSION python ./millegrilles/processus/OrienteurTransaction.py

