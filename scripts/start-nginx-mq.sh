#!/bin/env bash

CURRENTPWD=`pwd`
CONF="${CURRENTPWD}/nginx-mq.conf"
#CONF="${CURRENTPWD}/nginx-redmine.conf"
CERTS="/home/mathieu/mgdev/certs"

#docker run --rm \
#  -v "${CONF}:/etc/nginx/conf.d/nginx-mq.conf:ro" \
#  -v /home/mathieu/mgdev/certs:/certs:ro \
#  -p 1443:1443 \
#  -p 1444:1444 \
#  --network millegrille_net \
#  nginx

docker service create \
  --name nginxadmin \
  --mount "type=bind,source=${CONF},destination=/etc/nginx/conf.d/nginx-mq.conf,ro=true" \
  --mount "type=bind,source=${CERTS},destination=/certs,ro=true" \
  -p 1443:1443 \
  -p 1444:1444 \
  -p 1445:1445 \
  --network millegrille_net \
  nginx
