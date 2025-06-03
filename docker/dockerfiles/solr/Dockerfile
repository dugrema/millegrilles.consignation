# Use management image for RabbitMQ
FROM solr:9.2

ARG MG_DIR_ARG=/var/opt/millegrilles_solr

ENV MG_KEY=/run/secrets/key.pem \
    MG_CERT=/run/secrets/cert.pem \
    MG_CA=/run/secrets/pki.millegrille.cert \
    ZOOKEEPER_URL=solrzookeeper:2181 \
    MG_DIR=$MG_DIR_ARG \
    SOLR_MODULES="extraction"

COPY ./bin $MG_DIR_ARG/bin

CMD ${MG_DIR}/bin/configurerSsl.sh && \
    solr-foreground -c -h solr -z "${ZOOKEEPER_URL}" "$@"
