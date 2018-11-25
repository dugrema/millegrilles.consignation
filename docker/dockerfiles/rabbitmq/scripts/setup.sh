#!/bin/bash

echo "Executer l'ajout de plugins pour RabbitMQ"
rabbitmq-plugins enable --offline rabbitmq_shovel
rabbitmq-plugins enable --offline rabbitmq_shovel_management
echo "Plugins ajoutes"

echo "Copier la configuration des usagers"
mkdir -p $BUNDLE_FOLDER
cp $SRC_FOLDER/config/rabbitmq.config /etc/rabbitmq
cp $SRC_FOLDER/config/definitions.json $BUNDLE_FOLDER/

# Cleanup, supprimer le repertoire src/
cd /
rm -rf $SRC_FOLDER
