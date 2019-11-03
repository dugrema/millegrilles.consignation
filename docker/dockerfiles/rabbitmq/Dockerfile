# Use management image for RabbitMQ
FROM rabbitmq:3.8-management

ENV APP_SOURCE_FOLDER=/opt/rabbitmq/src \
    APP_BUNDLE_FOLDER=/opt/rabbitmq/dist \
    MG_CERTS_FOLDER=/usr/local/etc/millegrilles/certs

COPY ./scripts $APP_SOURCE_FOLDER/scripts
COPY ./config $APP_SOURCE_FOLDER/config

RUN $APP_SOURCE_FOLDER/scripts/setup.sh

VOLUME /opt/rabbitmq/conf

EXPOSE 5673
EXPOSE 8443

CMD run.sh
