#!/bin/env bash

CURRENTPWD=`pwd`
CONF="${CURRENTPWD}/nginx-mq.conf"
#CONF="${CURRENTPWD}/nginx-redmine.conf"
CERTS="/var/opt/millegrilles/secrets"
CONFIG="/var/opt/millegrilles/configuration"

#docker run --rm \
#  -v "${CONF}:/etc/nginx/conf.d/nginx-mq.conf:ro" \
#  -v "${CERTS}:/certs:ro" \
#  -v "${CONFIG}:/config:ro" \
#  -p 1443:1443 \
#  -p 1444:1444 \
#  --network millegrille_net \
#  nginx

docker service create \
  --name nginxadmin \
  --mount "type=bind,source=${CONF},destination=/etc/nginx/conf.d/nginx-mq.conf,ro=true" \
  --mount "type=bind,source=${CERTS},destination=/certs,ro=true" \
  --mount "type=bind,source=${CONFIG},destination=/config,ro=true" \
  --publish published=1443,target=1443,mode=host \
  --publish published=1444,target=1444,mode=host \
  --publish published=1445,target=1445,mode=host \
  --network millegrille_net \
  --network bridge \
  nginx

echo Passwords
echo "MQ"; cat ${CERTS}/passwd.mqadmin.txt; echo
echo "Mongo XP"; cat ${CERTS}/passwd.mongoexpress.txt; echo
