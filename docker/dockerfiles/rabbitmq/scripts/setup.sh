#!/bin/bash

echo "Executer l'ajout de plugins pour RabbitMQ"
rabbitmq-plugins enable --offline rabbitmq_shovel
rabbitmq-plugins enable --offline rabbitmq_shovel_management
rabbitmq-plugins enable --offline rabbitmq_auth_mechanism_ssl
echo "Plugins ajoutes"

echo "Copier la configuration des usagers"
mkdir -p $APP_BUNDLE_FOLDER
cp $APP_SOURCE_FOLDER/config/rabbitmq.config /etc/rabbitmq
cp $APP_SOURCE_FOLDER/config/definitions.json $APP_BUNDLE_FOLDER
# cp $APP_SOURCE_FOLDER/config/definitions_template.json $APP_BUNDLE_FOLDER

cp $APP_SOURCE_FOLDER/scripts/run.sh /usr/local/sbin
cp $APP_SOURCE_FOLDER/scripts/import_users.sh $APP_BUNDLE_FOLDER
cp $APP_SOURCE_FOLDER/scripts/monitor_user_operations.sh $APP_BUNDLE_FOLDER
cp $APP_SOURCE_FOLDER/scripts/update_definitions.sh $APP_BUNDLE_FOLDER

# Installer setcap pour permettre de demarrer sur port 443
apt-get update
apt-get install -y libcap2-bin

RABBITMQ_SERVER_FILE=/usr/lib/rabbitmq/lib/rabbitmq_server-3.7.8/sbin/rabbitmq-server
ERTS_FOLDER=/usr/lib/erlang/erts-9.3.3.3
setcap 'cap_net_bind_service=+ep' $RABBITMQ_SERVER_FILE
setcap 'cap_net_bind_service=+ep' $ERTS_FOLDER/bin/epmd
setcap 'cap_net_bind_service=+ep' $ERTS_FOLDER/bin/beam.smp

# Cleanup, supprimer le repertoire src/
cd /
rm -rf $APP_SOURCE_FOLDER
ln -s /usr/local/sbin/run.sh
