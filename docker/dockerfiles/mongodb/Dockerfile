# Image MongoDB
FROM mongo:4.0

MAINTAINER Mathieu Dugre <mail@mdugre.info>

CMD ["mongod", "--replSet", "rs0", "--sslMode", "requireSSL", "--sslPEMKeyFile", "/run/secrets/pki.millegrilles.ssl.key_cert", "--sslCAFile", "/run/secrets/pki.millegrilles.ssl.ca"]
