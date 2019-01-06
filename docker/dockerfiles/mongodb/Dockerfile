# Image MongoDB
FROM mongo:4.0
MAINTAINER Mathieu Dugre <mail@mdugre.info>

ENV APP_SOURCE_DIR=/opt/mongodb/src \
    APP_BUNDLE_DIR=/opt/mongodb/dist \
    MG_CERTS_FOLDER=/usr/local/etc/millegrilles/certs

COPY certs $MG_CERTS_FOLDER

VOLUME /opt/mongodb/conf

CMD ["mongod", "--replSet", "rs0", "--sslMode", "requireSSL", "--sslPEMKeyFile", "/run/secrets/pki.millegrilles.ssl.key_cert", "--sslCAFile", "/usr/local/etc/millegrilles/certs/millegrilles.authority.pem"]
