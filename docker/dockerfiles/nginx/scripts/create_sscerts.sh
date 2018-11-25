#!/bin/sh

cd ../dummy_certs

openssl genrsa -des3 -out server.key 2048
openssl req -new -key server.key -out server.csr
cp server.key server.key.org
openssl rsa -in server.key.org -out server.key
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

cp server.key ssl.maple.millegrilles.key
cp server.crt ssl.maple.millegrilles.cert

# Cleanup
#rm server.*
