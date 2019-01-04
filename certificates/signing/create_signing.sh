#!/usr/bin/env bash

CNF_FILE=openssl-millegrilles-signing.cnf
PRIVATE_PATH=~/certificates/millegrilles/privkeys
CAKEY=$PRIVATE_PATH/millegrilles_signing_key.pem
let "DAYS=365 * 5"  # 5 ans

if [ -f $CAKEY ]; then
  echo "Cle existe deja, on abort."
  exit 1
fi

openssl req \
        -config $CNF_FILE \
        -newkey rsa:8192 \
        -sha512 \
        -out millegrilles_signing_req.csr -outform PEM \
        -keyout $CAKEY -keyform PEM

# Creer backup de la cle
chmod 400 $CAKEY
cp $CAKEY $CAKEY.`date +%Y%m%d`

# Signer avec le certificat CA ROOT
CURRENT_PATH=$PWD
export CERT_OUTPUT_FILE=$PWD/millegrilles_signing_cert.pem
export REQUEST_FILE=$PWD/millegrilles_signing_req.csr
cd ../root
./sign_request.sh
cd $CURRENT_PATH
