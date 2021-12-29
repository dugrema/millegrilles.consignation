mongo 192.168.1.141:27017 \
  --authenticationDatabase admin \
  -u "admin" -p "example" \
  --tls --tlsCertificateKeyFile /certs/mongo.key_cert.pem \
  --tlsCAFile /certs/ca.cert

