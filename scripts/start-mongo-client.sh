#!/bin/env bash

VOL_CERTS="/home/mathieu/mgdev/certs"
# CERT="${VOL_CERTS}/mongo.cert"
# KEY="${VOL_CERTS}/mongo.key"
HOST=mongo

IMG=mongo:4.4

PASSWD_MONGO=`cat /var/opt/millegrilles/secrets/passwd.mongo.txt`

docker run --rm -it \
  -v "${VOL_CERTS}:/certs:rw" \
  --network millegrille_net \
  "${IMG}" \
  mongo "${HOST}:27017" \
  --verbose \
  --authenticationDatabase admin \
  -u "admin" -p "M2aWNG3ZcT/wyU/nDtbRmoallbUU0eyBUiU/+qpT4E0" \
  --tls --tlsCertificateKeyFile /certs/pki.mongo.key \
  --tlsCAFile /certs/pki.millegrille.cert
