#!/bin/bash

REPO=repository.maple.mdugre.info:5000
NAME=mg_rabbitmq
VERSION=1.0

IMAGENAME=$REPO/$NAME:$VERSION

sudo docker manifest create --insecure $IMAGENAME \
  $IMAGENAME.x86_64 \
  $IMAGENAME.armv7l

echo "Manifest updated: $IMAGENAME"

sudo docker manifest push --purge $IMAGENAME

