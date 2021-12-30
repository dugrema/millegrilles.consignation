#!/bin/env bash

VOL_CERTS="/home/mathieu/git/millegrilles.consignation/playground/scripts"
CERT="${VOL_CERTS}/mq.cert"
KEY="${VOL_CERTS}/mq.key"

IMG=rabbitmq:3.9.11-management-alpine

cat "${CERT}" "${VOL_CERTS}/ca.cert" > mq.chain.pem

docker run --rm -it \
  --hostname mq \
  -v "${VOL_CERTS}:/certs:rw" \
  -p 192.168.1.141:5673:5673 \
  -p 192.168.1.141:8080:8080 \
  -p 192.168.1.141:8443:8443 \
  "${IMG}" bash

# bash
