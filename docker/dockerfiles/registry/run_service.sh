#!/bin/bash

DOMAIN_CERT=/home/mathieu/.acme.sh/fs1.maple.maceroc.com_ecc
KEY_NAME=fs1.maple.maceroc.com.key

docker service create \
  --mount type=bind,source=${DOMAIN_CERT},destination=/opt/registry/secrets \
  --mount type=volume,source=registry,destination=/var/lib/registry \
  --env REGISTRY_HTTP_TLS_CERTIFICATE=/opt/registry/secrets/fullchain.cer \
  --env REGISTRY_HTTP_TLS_KEY=/opt/registry/secrets/${KEY_NAME} \
  --publish published=5000,target=443,mode=host \
  --name registry \
  docker.maceroc.com/mg_registry:x86_64_2.8.0

