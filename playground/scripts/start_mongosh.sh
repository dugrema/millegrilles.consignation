# HOST=192.168.1.141
HOST=amd8

#mongo "${HOST}:27017" \
#  --verbose \
#  --authenticationDatabase admin \
#  -u "admin" -p "example"

mongo "${HOST}:27017" \
  --verbose \
  --authenticationDatabase admin \
  -u "admin" -p "example" \
  --tls --tlsCertificateKeyFile /certs/mongo.key_cert.pem \
  --tlsCAFile /certs/ca.cert

#  --tlsAllowInvalidHostnames --tlsAllowInvalidCertificates



