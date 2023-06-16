#!/usr/bin/env bash

#SOLR_SSL_KEY_STORE=/tmp/keystore/solr-ssl.keystore.p12
if [ -z "${SOLR_SSL_KEY_STORE}" ]; then
  echo "SOLR_SSL_KEY_STORE absent de l'environnement"
  exit 1
fi

mkdir /tmp/keystore
chmod 700 /tmp/keystore

# Importer certificat de millegrille (CA)
keytool -import -trustcacerts \
  -storepass secret \
  -alias millegrille \
  -file "${MG_CA}" \
  -keystore "${SOLR_SSL_KEY_STORE}" \
  -noprompt

# Importer certificat avec cle
cat "${MG_CERT}" "${MG_CA}" > /tmp/keystore/cert.pem
openssl pkcs12 -export \
  -in /tmp/keystore/cert.pem -inkey "${MG_KEY}" \
  -name solrserver \
  -passout pass:secret \
  > /tmp/keystore/solrserver.p12

keytool -importkeystore \
  -srckeystore /tmp/keystore/solrserver.p12 \
  -srcstorepass secret \
  -srcstoretype pkcs12 \
  -destkeystore "${SOLR_SSL_KEY_STORE}" \
  -deststorepass secret \
  -alias solrserver

echo "--------------------------"
keytool -list -storepass secret -keystore ${SOLR_SSL_KEY_STORE}
echo "--------------------------"
