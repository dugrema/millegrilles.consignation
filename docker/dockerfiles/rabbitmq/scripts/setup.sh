#!/bin/bash

echo "Executer l'ajout de plugins pour RabbitMQ"
rabbitmq-plugins enable --offline rabbitmq_shovel
rabbitmq-plugins enable --offline rabbitmq_shovel_management
echo "Plugins ajoutes"

echo "Copier la configuration des usagers"
mkdir -p $BUNDLE_FOLDER
cp $SRC_FOLDER/config/rabbitmq.config /etc/rabbitmq
cp $SRC_FOLDER/config/definitions.json $BUNDLE_FOLDER/

# Installer setcap pour permettre de demarrer sur port 443
export http_proxy=http://192.168.1.28:8000
apt-get update
apt-get install -y libcap2-bin
setcap 'cap_net_bind_service=+ep' /usr/lib/rabbitmq/lib/rabbitmq_server-3.7.8/sbin/rabbitmq-server
setcap 'cap_net_bind_service=+ep' /usr/lib/erlang/erts-9.3.3.3/bin/epmd
setcap 'cap_net_bind_service=+ep' /usr/lib/erlang/erts-9.3.3.3/bin/beam.smp
apt-get autoclean

# Cleanup, supprimer le repertoire src/
cd /
rm -rf $SRC_FOLDER
