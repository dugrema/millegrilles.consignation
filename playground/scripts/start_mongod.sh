# docker-entrypoint.sh mongod

docker-entrypoint.sh mongod \
  --tlsMode requireTLS --tlsCertificateKeyFile /certs/mongo.key_cert.pem \
  --tlsCAFile /certs/ca.cert
  -p 192.168.2.195:27017:27017

#  --tlsAllowInvalidHostnames --tlsAllowInvalidCertificates

