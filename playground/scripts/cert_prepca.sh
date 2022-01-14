#!/bin/env bash

echo "Preparer la cle"
openssl genpkey -algorithm ED25519 > ca.key
# openssl genpkey -algorithm rsa > ca.key

echo "Generer CSR"
openssl req -new -out ca.csr -key ca.key -config openssl-25519-ca.cnf

echo "Signer CA (self)"
openssl x509 -req -days 7300 \
        -extensions v3_cert -extfile ssl-extensions-ca.cnf \
        -in ca.csr -signkey ca.key -out ca.cert

echo "Preparer fichier serie certs (01)"
echo "01" > ca.srl
