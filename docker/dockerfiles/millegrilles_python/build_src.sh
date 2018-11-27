#!/bin/bash

FOLDER_SRC=src
GIT_SERVEUR=ssh://repository.maple.mdugre.info/var/lib/git
GIT_PROJET=MilleGrilles.consignation.python
BRANCH=v0.4

if [ ! -d $FOLDER_SRC/$GIT_PROJET ]; then
  echo "Creation folder $FOLDER_SRC/$GIT_PROJET"
  mkdir -p $FOLDER_SRC/$GIT_PROJET
fi

cd $FOLDER_SRC/
if [ ! -d $GIT_PROJET/.git ]; then
  echo "Clone branch"
  git clone --single-branch -b $BRANCH \
      $GIT_SERVEUR/$GIT_PROJET.git
fi
# S'assurer d'avoir le code le plus recent
cd $GIT_PROJET
git pull

python3 setup.py build

cd ../..
