# docker-entrypoint.sh mongod

docker-entrypoint.sh mongod \
  --tlsMode requireTLS --tlsCertificateKeyFile /certs/mongo.key_cert.pem \
  --tlsCAFile /certs/ca.cert

#  --tlsAllowInvalidHostnames --tlsAllowInvalidCertificates

