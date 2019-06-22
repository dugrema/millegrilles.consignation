#!/usr/bin/env bash

# echo "Executer la preparation de definitions.json"

# cd $APP_BUNDLE_FOLDER
# $APP_BUNDLE_FOLDER/update_definitions.sh > $APP_BUNDLE_FOLDER/definitions_tmp.json
# if [ $? -eq 0 ]; then
#   echo "Application du fichier de configuration modifie definitions.json"
#   mv $APP_BUNDLE_FOLDER/definitions.json $APP_BUNDLE_FOLDER/definitions.json.original
#   mv $APP_BUNDLE_FOLDER/definitions_tmp.json $APP_BUNDLE_FOLDER/definitions.json
# else
#   echo "Erreur preparation definitions.json, utilisation du fichier par defaut."
# fi

cd /

echo "Demarrage script de traitement des usagers"
/opt/rabbitmq/dist/monitor_user_operations.sh &

echo "Demarrage rabbitmq-server"
docker-entrypoint.sh rabbitmq-server
