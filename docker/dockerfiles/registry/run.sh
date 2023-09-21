#!/usr/bin/env bash

MOUNT_PATH=/home/mathieu/tmp/registry
PORT=5000

docker run \
  --mount type=bind,source=$MOUNT_PATH/secrets,destination=/opt/registry/secrets \
  --mount type=bind,source=$MOUNT_PATH/dist,destination=/var/lib/registry \
  -p $PORT:443 \
  registry:htpasswd
