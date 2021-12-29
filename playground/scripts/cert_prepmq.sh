#!/bin/env bash

KEYNAME=mq
CNF="openssl-25519-${KEYNAME}.cnf"

echo "Preparer la cle"
openssl genpkey -algorithm ED25519 > "${KEYNAME}.key"

echo "Generer CSR"
openssl req -new -out "${KEYNAME}.csr" -key "${KEYNAME}.key" -config "${CNF}"

echo "Signer certificat"
openssl x509 -req -days 30 \
  -extensions v3_cert -extfile ssl-extensions-x509.cnf \
  -in "${KEYNAME}.csr" -CA "ca.cert" -CAkey "ca.key" \
  -out "${KEYNAME}.cert"
