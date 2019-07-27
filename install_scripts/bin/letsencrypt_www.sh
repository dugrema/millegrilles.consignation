#!/bin/sh

MESSAGE_AIDE_1='Il manque les parametres: DOMAIN OPT_MILLEGRILLES_FOLDER'
MESSAGE_AIDE_2='Exemple: letsencrypt_www.sh maple.millegrilles.mdugre.info /opt/millegrilles/maple'

if [ -z $2 ]; then
  echo $MESSAGE_AIDE_1
  echo $MESSAGE_AIDE_2
  exit 1
fi

DOMAIN=$1
OPT_MILLEGRILLES_FOLDER=$2

# sudo certbot certonly \
# --config-dir $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt \
# --expand --webroot -w $OPT_MILLEGRILLES_FOLDER/nginx/webroot \
# -d www.$DOMAIN -d coupdoeil.$DOMAIN

sudo certbot renew -n \
--config-dir $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt \
--expand --webroot -w $OPT_MILLEGRILLES_FOLDER/nginx/webroot \
--post-hook "./letsencrypt_renewhook.sh $DOMAIN $OPT_MILLEGRILLES_FOLDER"

