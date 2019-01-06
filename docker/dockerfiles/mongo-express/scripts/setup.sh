#!/bin/bash

echo "Copie du fichier run.sh vers $BUNDLE_FOLDER"
chmod 755 $SRC_FOLDER/scripts/run.sh

mkdir -p $BUNDLE_FOLDER
cp $SRC_FOLDER/scripts/run.sh $BUNDLE_FOLDER

echo "Override des fichiers config.js et lib/db.js pour supporter certificats"
cp $SRC_FOLDER/config.js /node_modules/mongo-express
cp $SRC_FOLDER/db.js /node_modules/mongo-express/lib

echo "Suppression du folder $SRC_FOLDER"
rm -rf $SRC_FOLDER

echo "Setup termine"
