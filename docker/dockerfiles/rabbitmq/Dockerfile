# Use management image for RabbitMQ
FROM rabbitmq:3.7-management

ENV SRC_FOLDER=/opt/rabbitmq/src \
    BUNDLE_FOLDER=/opt/rabbitmq/dist

COPY ./scripts $SRC_FOLDER/scripts
COPY ./config $SRC_FOLDER/config

RUN $SRC_FOLDER/scripts/setup.sh

#RUN rabbitmq-plugins enable --offline rabbitmq_shovel && \
#    rabbitmq-plugins enable --offline rabbitmq_shovel_management

