#!/bin/env bash

VOL_CERTS="/home/mathieu/git/millegrilles.consignation/playground/scripts"
CERT="${VOL_CERTS}/mq.cert"
KEY="${VOL_CERTS}/mq.key"

IMG=rabbitmq:3.9.11-management-alpine

ADDR_IP=192.168.2.195

cat "${CERT}" "${VOL_CERTS}/ca.cert" > mq.chain.pem

docker run --rm -it \
  --hostname mq \
  -v "${VOL_CERTS}:/certs:rw" \
  -p ${ADDR_IP}:5673:5673 \
  -p ${ADDR_IP}:8080:8080 \
  -p ${ADDR_IP}:8443:8443 \
  "${IMG}" bash


# bash
