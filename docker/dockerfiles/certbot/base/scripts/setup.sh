#!/bin/sh

echo "Copie des fichiers vers $APP_BUNDLE_DIR"
mkdir -p $APP_SOURCE_DIR $APP_BUNDLE_DIR

echo "Installation des dependances Python"
pip3 install -r $APP_SOURCE_DIR/scripts/requirements.txt

apt update
apt install certbot -y

# Fix pymongo, erreur cannot import abc (issue #305)
pip3 uninstall -y bson
pip3 uninstall -y pymongo
pip3 install pymongo

echo "Setup termine"
