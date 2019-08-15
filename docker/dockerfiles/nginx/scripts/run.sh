#!/bin/bash

SECRET=/run/secrets
NGINX=/usr/sbin/nginx
CONF=/etc/nginx/conf.d
REPLACE_VARS='${URL_DOMAIN},${WEB_CERT},${COUPDOEIL_IP},${NOM_MILLEGRILLE}'

if [[ ! -d $SECRET ]]; then
  echo "Folder secret n'existe pas, on installe les certificats de test"
  mkdir -p $SECRET
  cp $APP_BUNDLE_DIR/dummy_certs/* $SECRET
fi

# Creer les liens vers les cers/cles
echo "Creation liens pour WEB_CERT=$WEB_CERT et WEB_KEY=$WEB_KEY."
ln -s /run/secrets/$WEB_CERT $APP_BUNDLE_DIR/cert.pem
ln -s /run/secrets/$WEB_KEY $APP_BUNDLE_DIR/key.pem

echo "Liste secrets"
ls -l /run/secrets

echo "Certificat utilise"
cat $APP_BUNDLE_DIR/cert.pem

# Effectuer substitution des variables d'Environnement
# if [ -z $NGINX_NOOVERRIDE_CONF ]; then
#   if [ -z $NGINX_CONFIG_FILE ]; then
#     echo "Utilisation fichier configuration bundle default.conf"
#     envsubst $REPLACE_VARS < $APP_BUNDLE_DIR/sites-available/default.conf > $CONF/default.conf
#   else
#     echo "Utilisation fichier configuration dans bundle: $NGINX_CONFIG_FILE"
#     envsubst $REPLACE_VARS < $APP_BUNDLE_DIR/sites-available/$NGINX_CONFIG_FILE > $CONF/default.conf
#   fi
# fi

if [ -z $NGINX_CONFIG_FILE ]; then
  NGINX_CONFIG_FILE=default.conf
fi

CONFIG_FILE=$APP_BUNDLE_DIR/sites-available/$NGINX_CONFIG_FILE
CONFIG_EFFECTIVE=$APP_BUNDLE_DIR/nginx-site.conf

if [ ! -f $CONFIG_EFFECTIVE ]; then
  export COUPDOEIL_IP=`getent hosts coupdoeilreact | awk '{print $1}'`
  echo "Adresse IP interne de coupdoeilreact: $COUPDOEILIP"

  echo "Utilisation fichier configuration dans bundle: $NGINX_CONFIG_FILE"
  envsubst $REPLACE_VARS < $APP_BUNDLE_DIR/sites-available/$NGINX_CONFIG_FILE > $CONFIG_EFFECTIVE
else
  echo "[WARN] Fichier de configuration existe deja: $CONFIG_EFFECTIVE"
  echo "On assume que le fichier est controle de maniere externe, aucune modification faite"
fi

echo Creation lien vers $NGINX_CONFIG_FILE sous /etc/nginx/conf.d
ln -s $CONFIG_EFFECTIVE /etc/nginx/conf.d/$NGINX_CONFIG_FILE


echo "Demarrage de nginx avec configuration $NGINX_CONFIG_FILE"
nginx -g "daemon off;"
