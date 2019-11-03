#!/bin/bash

echo "Executer l'ajout de plugins pour RabbitMQ"
rabbitmq-plugins enable --offline rabbitmq_shovel
rabbitmq-plugins enable --offline rabbitmq_shovel_management
rabbitmq-plugins enable --offline rabbitmq_auth_mechanism_ssl
rabbitmq-plugins enable --offline rabbitmq_federation
rabbitmq-plugins enable --offline rabbitmq_federation_management
echo "Plugins ajoutes"

echo "Copier la configuration des usagers"
mkdir -p $APP_BUNDLE_FOLDER
cp $APP_SOURCE_FOLDER/config/rabbitmq.config /etc/rabbitmq
cp -r $APP_SOURCE_FOLDER/config $APP_BUNDLE_FOLDER
cp $APP_SOURCE_FOLDER/config/definitions.json $APP_BUNDLE_FOLDER

cp $APP_SOURCE_FOLDER/scripts/run.sh /usr/local/sbin
cp $APP_SOURCE_FOLDER/scripts/import_users.sh $APP_BUNDLE_FOLDER
cp $APP_SOURCE_FOLDER/scripts/monitor_user_operations.sh $APP_BUNDLE_FOLDER
cp $APP_SOURCE_FOLDER/scripts/update_definitions.sh $APP_BUNDLE_FOLDER

# Preparer repertoires pour certs et keys
mkdir -p $APP_BUNDLE_FOLDER/certs $APP_BUNDLE_FOLDER/keys

# Cleanup, supprimer le repertoire src/
cd /
rm -rf $APP_SOURCE_FOLDER
ln -s /usr/local/sbin/run.sh
