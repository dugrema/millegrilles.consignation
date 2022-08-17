#!/bin/env bash

CACHE_PATH="/var/cache/npm-proxy"
IMG="docker.maceroc.com/npm-proxy-cache:1"

sudo mkdir -p $CACHE_PATH

docker service create \
  --name npmproxy \
  --mount "type=bind,source=${CACHE_PATH},destination=/opt/npm-proxy-cache/cache" \
  -p 8001:8080 \
  $IMG \
  --port 8080 --host 0.0.0.0 --expired
