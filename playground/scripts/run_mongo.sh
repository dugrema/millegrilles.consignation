#!/bin/env bash

VOL_CERTS="/home/mathieu/git/millegrilles.consignation/playground/scripts"
CERT="${VOL_CERTS}/mongo.cert"
KEY="${VOL_CERTS}/mongo.key"

IMG=mongo:4.4

export MONGO_INITDB_ROOT_USERNAME=admin
# export MONGO_INITDB_ROOT_PASSWORD_FILE=/certs/mongo.passwd.txt
export MONGO_INITDB_ROOT_PASSWORD=example

cat mongo.key mongo.cert ca.cert > mongo.key_cert.pem

docker run --rm -it \
  --hostname mongo \
  -v "${VOL_CERTS}:/certs:rw" \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME -e MONGO_INITDB_ROOT_PASSWORD \
  "${IMG}" bash
