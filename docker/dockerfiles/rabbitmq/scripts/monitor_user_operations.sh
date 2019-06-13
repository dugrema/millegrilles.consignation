#!/usr/bin/env bash

SCRIPT_PATH=/opt/rabbitmq/dist
FILE_PATH=/opt/rabbitmq/conf
USER_FILE=$FILE_PATH/new_users.txt
PROCESS_FILE=$FILE_PATH/processing_users.txt

while :
do
  if [ -e $USER_FILE ]; then
    echo "Traitement des fichiers d'usagers"

    # Copier contenu du fichier et supprimer fichier user.
    cat $USER_FILE > $PROCESS_FILE
    rm $USER_FILE
    $SCRIPT_PATH/import_users.sh $PROCESS_FILE

    echo "Traitement termine, suppression du fichier d'usagers"
    rm $PROCESS_FILE
  fi
  sleep 10
done
