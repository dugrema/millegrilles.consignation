# Use management image for RabbitMQ
FROM zookeeper:3.8

ARG MG_DIR_ARG=/var/opt/millegrilles_zookeeper
ARG KEYSTORE_ARG=/tmp/keystore/solr-ssl.keystore.p12

ENV MG_KEY=/run/secrets/key.pem \
    MG_CERT=/run/secrets/cert.pem \
    MG_CA=/run/secrets/pki.millegrille.cert \
    MG_DIR=${MG_DIR_ARG} \
    KEYSTORE=${KEYSTORE_ARG}

ENV SERVER_JVMFLAGS="-Dzookeeper.serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory -Dzookeeper.ssl.keyStore.location=${KEYSTORE}  -Dzookeeper.ssl.keyStore.password=secret -Dzookeeper.ssl.trustStore.location=${KEYSTORE} -Dzookeeper.ssl.trustStore.password=secret"

COPY ./bin $MG_DIR_ARG/bin

CMD ${MG_DIR}/bin/preparerKeystore.sh && \
    zkServer.sh start-foreground -Dsolr.ssl.checkPeerName=false
