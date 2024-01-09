# Use management image for RabbitMQ
FROM rabbitmq:3.13-management

ENV APP_SOURCE_FOLDER=/opt/rabbitmq/src \
    APP_BUNDLE_FOLDER=/opt/rabbitmq/dist \
    MG_CERTS_FOLDER=/opt/rabbitmq/dist/certs \
    CONFIG_FILE=/opt/rabbitmq/dist/config/rabbitmq_ipv6management.config

COPY ./scripts $APP_SOURCE_FOLDER/scripts
COPY ./config $APP_SOURCE_FOLDER/config

RUN $APP_SOURCE_FOLDER/scripts/setup.sh

VOLUME /opt/rabbitmq/conf

EXPOSE 5673
EXPOSE 8443

CMD /run.sh
# CMD /usr/local/bin/docker-entrypoint.sh