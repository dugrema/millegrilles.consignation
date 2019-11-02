#!/usr/bin/env bash

REPO=registry.maple.mdugre.info:5000
VERSION=3.8-management_0

docker run \
  --mount type=bind,source=/home/mathieu/tmp/mq/certs,target=/opt/rabbitmq/dist/certs \
  --mount type=bind,source=/home/mathieu/tmp/mq/keys,target=/opt/rabbitmq/dist/keys \
  -p 8443:8443 \
  -p 5671-5673:5671-5673 \
  $REPO/mg_rabbitmq.x86_64:$VERSION
