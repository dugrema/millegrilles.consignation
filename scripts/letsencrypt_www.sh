#!/bin/sh

MESSAGE_AIDE_1='Il manque les parametres: DOMAIN WEBROOT'
MESSAGE_AIDE_2='Exemple: letsencrypt_www.sh maple.millegrilles.mdugre.info /opt/millegrilles/maple/webroot'

if [ -z $2 ]; then
  echo $MESSAGE_AIDE_1
  echo $MESSAGE_AIDE_2
  exit 1
fi

DOMAIN=$1
WEBROOT=$2

sudo certbot certonly -d www.$DOMAIN --expand --webroot -w $WEBROOT \
-d coupdoeil.$DOMAIN
