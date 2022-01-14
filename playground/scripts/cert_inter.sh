#!/bin/env bash

KEYNAME=inter
CNF="openssl-25519-${KEYNAME}.cnf"

echo "Preparer la cle"
openssl genpkey -algorithm ED25519 > "${KEYNAME}.key"
# openssl genpkey -algorithm rsa > "${KEYNAME}.key"

echo "Generer CSR"
openssl req -new -out "${KEYNAME}.csr" -key "${KEYNAME}.key" -config "${CNF}"

echo "Signer certificat"
openssl x509 -req -days 30 \
  -extensions v3_cert -extfile ssl-extensions-inter.cnf \
  -in "${KEYNAME}.csr" -CA "ca.cert" -CAkey "ca.key" \
  -out "${KEYNAME}.cert"

echo "Preparer fichier serie certs (01)"
echo "01" > inter.srl

