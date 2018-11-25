#!/bin/bash

SECRET=/run/secrets
NGINX=/usr/sbin/nginx

if [[ ! -d $SECRET ]]; then
  echo "Folder secret n'existe pas, on installe les certificats de test"
  mkdir -p $SECRET
  cp $APP_BUNDLE_DIR/dummy_certs/* $SECRET
fi

echo "Demarrage de nginx"
nginx -g "daemon off;"
