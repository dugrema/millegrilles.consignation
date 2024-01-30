#!/bin/bash

# Supprime les fichiers qui sont presents dans la liste (pipe)

SRC=`pwd`

while read f; do
  if [ -f "${SRC}/${f}" ]; then
    echo "Supprimer $f"
    rm "${SRC}/$f"
  fi
done
