#!/usr/bin/env bash

if [ -z $CERT_OUTPUT_FILE ]; then
  echo "CERT_OUTPUT_FILE file doit etre fourni"
  exit 1
fi

if [ ! -f $REQUEST_FILE ]; then
  echo "Request file pas accessible: $REQUEST_FILE"
  exit 2
fi

CNF_FILE=openssl-millegrilles-signing.cnf
PRIVATE_PATH=~/certificates/millegrilles/privkeys
CAKEY=$PRIVATE_PATH/millegrilles_signingkey.pem
let "DAYS=365 * 1"  # 1 an

if [ ! -f $CAKEY ]; then
  echo "Cle Signing introuvable: $CAKEY"
  exit 1
fi

openssl ca -config $CNF_FILE \
        -policy signing_policy \
        -extensions signing_req \
        -keyfile $CAKEY -keyform PEM \
        -out $CERT_OUTPUT_FILE \
        -infiles $REQUEST_FILE
