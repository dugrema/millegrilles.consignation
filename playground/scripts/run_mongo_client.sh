#!/bin/env bash

VOL_CERTS="/home/mathieu/git/millegrilles.consignation/playground/scripts"
CERT="${VOL_CERTS}/mongo.cert"
KEY="${VOL_CERTS}/mongo.key"

IMG=mongo:4.4

cat mongo.key mongo.cert ca.cert > mongo.key_cert.pem

docker run --rm -it \
  -v "${VOL_CERTS}:/certs:rw" \
  "${IMG}" bash
