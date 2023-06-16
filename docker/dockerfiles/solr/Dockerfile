# Use management image for RabbitMQ
FROM solr:9.2

ARG MG_DIR=/var/opt/millegrilles_solr

ENV SOLR_SSL_ENABLED=true \
    SOLR_SSL_KEY_STORE=/tmp/keystore/solr-ssl.keystore.p12 \
    SOLR_SSL_KEY_STORE_PASSWORD=secret \
    SOLR_SSL_TRUST_STORE=/tmp/keystore/solr-ssl.keystore.p12 \
    SOLR_SSL_TRUST_STORE_PASSWORD=secret \
    SOLR_SSL_NEED_CLIENT_AUTH=true \
    SOLR_SSL_WANT_CLIENT_AUTH=true \
    SOLR_SSL_CHECK_PEER_NAME=true \
    MG_KEY=/run/secrets/key.pem \
    MG_CERT=/run/secrets/cert.pem \
    MG_CA=/run/secrets/pki.millegrille.cert \
    ZOOKEEPER_URL=solrzookeeper:2181

COPY ./bin $MG_DIR/bin

CMD /var/opt/millegrilles_solr/bin/preparerKeystore.sh && \
    solr-foreground -c -z "${ZOOKEEPER_URL}" "$@"
