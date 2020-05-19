#!/bin/bash

source image_info.txt

CONF_FOLDER=`pwd`/config-test

# Override version (e.g. pour utiliser x86_64_...)
VERSION=x86_64_1.18_0

# docker run -d --rm \
#   -p 80:80 \
#   -p 443:443 \
#   $REPO/$NAME:$VERSION

# docker run --rm -it \
#   -p 80:80 \
#   -p 443:443 \
#   -v $CONF_FOLDER:/etc/nginx/conf.d \
#   -v /home/mathieu/mgdev/certs:/certs \
#   $REPO/$NAME:$VERSION

docker run --rm \
  --network host \
  -v $CONF_FOLDER:/etc/nginx/conf.d \
  -v /home/mathieu/mgdev/certs:/certs \
  $REPO/$NAME:$VERSION
