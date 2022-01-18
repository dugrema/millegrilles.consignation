#!/bin/env bash

CURRENTPWD=`pwd`
CONF="${CURRENTPWD}/nginx-mq.conf"

docker run --rm \
  -v "${CONF}:/etc/nginx/conf.d/nginx-mq.conf:ro" \
  -v /home/mathieu/mgdev/certs:/certs:ro \
  -p 1443:1443 \
  nginx
