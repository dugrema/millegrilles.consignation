#!/bin/bash
GIT_NAME=MilleGrilles.domaines.python
GIT_FOLDER=$SRC_FOLDER/$GIT_NAME

echo "Installer dependances Python avec pip: fichier $GIT_FOLDER/requirements.txt"
pip install --no-cache-dir -r $GIT_FOLDER/requirements.txt

echo Installer package MilleGrilles.domaines
cd $GIT_FOLDER
python3 setup.py install

#echo "Copier script demarrer dans $BUNDLE_FOLDER"
#mkdir -p $BUNDLE_FOLDER
cp $GIT_FOLDER/demarrer*.py $BUNDLE_FOLDER

cd $BUNDLE_FOLDER
rm -rf $BUILD_FOLDER
