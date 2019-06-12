#!/usr/bin/env bash

cd /opt/rabbitmq/dist

mkdir -p /run/secrets

cat millegrilles.RootCA.pem \
    millegrille_dev2.maple.mdugre.info.cert.pem.fullchain > \
    /run/secrets/pki.millegrilles.ssl.CAchain

cp dev2.maple.mdugre.info.cert.pem /run/secrets/pki.millegrilles.ssl.cert
cp dev2.maple.mdugre.info.key.pem /run/secrets/pki.millegrilles.ssl.key

cp dev2.maple.mdugre.info.cert.pem /run/secrets/pki.millegrilles.web.cert
cp dev2.maple.mdugre.info.key.pem /run/secrets/pki.millegrilles.web.key

cp -f rabbitmq.config /etc/rabbitmq
