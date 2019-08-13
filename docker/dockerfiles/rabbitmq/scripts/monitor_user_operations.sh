#!/usr/bin/env bash

SCRIPT_PATH=/opt/rabbitmq/dist
FILE_PATH=/opt/rabbitmq/conf
USER_FILE=$FILE_PATH/new_users.txt
PROCESS_FILE=$FILE_PATH/processing_users.txt

# Si un fichier de creation d'usagers est present au demarrage,
# il faut donner le temps au server de demarrer.
# Sinon on recoit code d'erreur 69.
sleep 60

while :
do
  if [ -e $USER_FILE ]; then
    echo "Traitement des fichiers d'usagers"

    rabbitmqctl ping
    PING=$?
    if [ $PING -eq 0 ]; then
      # Copier contenu du fichier et supprimer fichier user.
      cat $USER_FILE > $PROCESS_FILE
      rm $USER_FILE
      $SCRIPT_PATH/import_users.sh $PROCESS_FILE

      echo "Traitement termine, suppression du fichier d'usagers"
      rm $PROCESS_FILE
    else
      echo "Erreur ping rabbitmqctl, code=$PING"
    fi
  fi
  sleep 15
done
