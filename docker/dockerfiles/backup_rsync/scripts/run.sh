#!/bin/sh

PATH_CLE='/secret'

if [ -z $SRC ]; then
  echo "ERREUR : SRC vide"
  exit 1
fi

chmod 700 $PATH_CLE

if [ ! -f "${PATH_CLE}/id_ed25519" ]; then
  ssh-keygen -q -t ed25519 -f "${PATH_CLE}/id_ed25519" -N ""
  echo "Cle ed25519 cree"
fi
if [ ! -f "${PATH_CLE}/id_rsa" ]; then
  ssh-keygen -q -t rsa -f "${PATH_CLE}/id_rsa" -N ""
  echo "Cle RSA cree"
fi

echo "Cle SSH de backup"
cat "${PATH_CLE}/id_ed25519.pub"
cat "${PATH_CLE}/id_rsa.pub"

echo "Backup vers $DEST"
find $SRC

echo "Debut du backup vers $DEST"
rsync -r -e "ssh -i $PATH_CLE/id_ed25519 -i $PATH_CLE/id_rsa -o StrictHostKeyChecking=no" $SRC/* $DEST
EXIT_CODE=$?
if [ "$EXIT_CODE" -ne 0 ]; then
  echo "ERREUR, backup incomplet"
  exit $EXIT_CODE
fi
echo "Fin du backup vers $DEST"
