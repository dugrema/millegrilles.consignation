FROM alpine

#############################################################
#
# ENV VARS
#
# HARDWARE_PORT          Hardware without SSL/TLS support
# HARDWARE_PORT_SSL      Hardware port with SSL/TLS support
# HTTP_PORT              Blynk Dashboard
#
# BLYNK_SERVER_VERSION   Blynk Server JAR version
#
###

## Server Port
ARG BLYNK_SERVER_VERSION=0.41.10
ARG HARDWARE_MQTT_PORT=8440
ARG HARDWARE_MQTT_PORT_SSL=8443
ARG HTTP_PORT=8080
ARG HTTPS_PORT=9443

## Opt env
# SERVER_SSL_CERT
# SERVER_SSL_KEY
# SERVER_SSL_KEY_PASS

ENV HARDWARE_MQTT_PORT=${HARDWARE_MQTT_PORT} \
    HARDWARE_MQTT_PORT_SSL=${HARDWARE_MQTT_PORT_SSL} \
    HTTP_PORT=${HTTP_PORT} \
		HTTPS_PORT=${HTTPS_PORT} \
    LOG_LEVEL=info \
    FORCE_PORT_80_FOR_CSV=false \
    FORCE_PORT_80_FOR_REDIRECT=true \
    USER_DEVICES_LIMIT=50 \
    USER_TAGS_LIMIT=100 \
    USER_DASHBOARD_MAX_LIMIT=100 \
    USER_WIDGET_MAX_SIZE_LIMIT=20 \
    USER_MESSAGE_QUOTA_LIMIT=100 \
    NOTIFICATIONS_QUEUE_LIMIT=2000 \
    BLOCKING_PROCESSOR_THREAD_POOL_LIMIT=6 \
    NOTIFICATIONS_FREQUENCY_USER_QUOTA_LIMIT=5 \
    WEBHOOKS_FREQUENCY_USER_QUOTA_LIMIT=1000 \
    WEBHOOKS_RESPONSE_SIZE_LIMIT=96 \
    USER_PROFILE_MAX_SIZE=128 \
    TERMINAL_STRINGS_POOL_SIZE=25 \
    MAP_STRINGS_POOL_SIZE=25 \
    LCD_STRINGS_POOL_SIZE=6 \
    TABLE_ROWS_POOL_SIZE=100 \
    PROFILE_SAVE_WORKER_PERIOD=60000 \
    STATS_PRINT_WORKER_PERIOD=60000 \
    WEB_REQUEST_MAX_SIZE=524288 \
    CSV_EXPORT_DATA_POINT_MAX=43200 \
    HARD_SOCKET_IDLE_TIMEOUT=10 \
    ADMIN_ROOT_PATH=/admin \
    PRODUCT_NAME=Blynk \
    RESTORE_HOST=blynk-cloud.com \
    ALLOW_STORE_IP=true \
    ALLOW_READING_WIDGET_WITHOUT_ACTIVE_APP=false \
    ASYNC_LOGGER_RING_BUFFER_SIZE=2048 \
    ENABLE_DB=false \
    ENABLE_RAW_DB_DATA_STORE=false \
    INITIAL_ENERGY=100000 \
    ADMIN_EMAIL=admin@blynk.cc \
    ADMIN_PASS=admin \
		DATA_FOLDER=/blynk/data

RUN apk update && apk upgrade && \
    apk add --no-cache --update openjdk8-jre curl unzip && \
    mkdir -p /blynk/data && \
    mkdir /blynk/config && \
    mkdir /logs && \
    touch /logs/server.log && \
    touch /logs/blynk.log && \
    touch /logs/worker.log && \
		curl -L https://github.com/blynkkk/blynk-server/releases/download/v${BLYNK_SERVER_VERSION}/server-${BLYNK_SERVER_VERSION}-java8.jar > /blynk/server.jar && \
		curl -L https://github.com/blynkkk/blynk-server/archive/v${BLYNK_SERVER_VERSION}.zip > /tmp/server.zip && \
    unzip /tmp/server.zip && \
		mv /blynk-server-${BLYNK_SERVER_VERSION}/server/core/src/main/resources/server.properties /blynk/config/server.properties && \
    apk del --purge curl unzip && \
		rm -rf /blynk-server-${BLYNK_SERVER_VERSION} && \
    rm -rf /var/cache/apk/*

VOLUME ["/blynk/config", "/blynk/data"]

EXPOSE ${HARDWARE_MQTT_PORT} ${HARDWARE_MQTT_PORT_SSL} ${HTTP_PORT} ${HTTPS_PORT}

ENTRYPOINT ["/usr/local/bin/run.sh"]

COPY /bin /usr/local/bin
