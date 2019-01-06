# Use management image for RabbitMQ
FROM rabbitmq:3.7-management

ENV APP_SOURCE_FOLDER=/opt/rabbitmq/src \
    APP_BUNDLE_FOLDER=/opt/rabbitmq/dist \
    MG_CERTS_FOLDER=/usr/local/etc/millegrilles/certs

COPY ./scripts $APP_SOURCE_FOLDER/scripts
COPY ./config $APP_SOURCE_FOLDER/config
COPY certs $MG_CERTS_FOLDER/

RUN $APP_SOURCE_FOLDER/scripts/setup.sh

VOLUME /opt/rabbitmq/conf

EXPOSE 443
EXPOSE 15671

EXPOSE 15672
