#!/usr/bin/env bash

CNF_FILE=openssl-ca.cnf
PRIVATE_PATH=~/certificates/millegrilles/privkeys
CAKEY=$PRIVATE_PATH/millegrilles_cakey.pem
let "DAYS=365 * 10"  # 10 ans

if [ -f $CAKEY ]; then
  echo "Cle existe deja, on abort."
  exit 1
fi

openssl req -x509 \
        -config $CNF_FILE \
        -newkey rsa:8192 \
        -sha512 \
        -days $DAYS \
        -out millegrilles_cacert.pem -outform PEM \
        -keyout $CAKEY -keyform PEM

# Creer backup de la cle
chmod 400 $CAKEY
cp $CAKEY.`date +%Y%m%d`
