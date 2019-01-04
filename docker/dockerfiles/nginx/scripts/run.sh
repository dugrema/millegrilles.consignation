#!/bin/bash

SECRET=/run/secrets
NGINX=/usr/sbin/nginx
CONF=/etc/nginx/conf.d

if [[ ! -d $SECRET ]]; then
  echo "Folder secret n'existe pas, on installe les certificats de test"
  mkdir -p $SECRET
  cp $APP_BUNDLE_DIR/dummy_certs/* $SECRET
fi

# Effectuer substitution des variables d'Environnement
if [ -z $NGINX_NOOVERRIDE_CONF ]; then
  if [ -z $NGINX_CONFIG_FILE ]; then
    echo "Utilisation fichier configuration bundle default.conf"
    envsubst < $APP_BUNDLE_DIR/sites-available/default.conf > $CONF/default.conf
  else
    echo "Utilisation fichier configuration dans bundle: $NGINX_CONFIG_FILE"
    envsubst < $APP_BUNDLE_DIR/sites-available/$NGINX_CONFIG_FILE > $CONF/default.conf
  fi
fi

echo "Demarrage de nginx"
nginx -g "daemon off;"
