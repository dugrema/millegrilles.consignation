#!/usr/bin/env bash

CNF_FILE=openssl-ca.cnf
PRIVATE_PATH=~/certificates/millegrilles/privkeys
let "DAYS=365 * 10"  # 10 ans

openssl req -x509 \
        -config $CNF_FILE \
        -newkey rsa:8192 \
        -sha512 \
        -days $DAYS \
        -out cacert.pem -outform PEM \
        -keyout $PRIVATE_PATH/cakey.pem -keyform PEM
