#!/bin/bash

# Supprime de la SRC les fichiers de la liste (pipe) qui sont aussi presents dans la DEST

if [ -z $1 ]; then
  echo "Il faut fournir le repertoire de comparaison"
  exit 1
fi

SRC=`pwd`
DEST=$1

while read f; do
  if [ -f "${DEST}/${f}" ]; then
    echo "$f existe, on supprime"
    rm "${SRC}/$f"
  else
    echo "$f manquant"
  fi
done
