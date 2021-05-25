#!/bin/sh

PATH_CLE='/secret/id_ed25519'

if [ -z $SRC ]; then
  echo "ERREUR : SRC vide"
  exit 1
fi

if [ ! -f $PATH_CLE ]; then
  ssh-keygen -q -t ed25519 -f $PATH_CLE -N ""
fi

echo "Cle SSH de backup"
cat "${PATH_CLE}.pub"

echo "Backup vers $DEST"
find $SRC

echo "Debut du backup vers $DEST"
rsync -r -e "ssh -i $PATH_CLE -o StrictHostKeyChecking=no" $SRC/* $DEST
EXIT_CODE=$?
if [ "$EXIT_CODE" -ne 0 ]; then
  echo "ERREUR, backup incomplet"
  exit $EXIT_CODE
fi
echo "Fin du backup vers $DEST"
