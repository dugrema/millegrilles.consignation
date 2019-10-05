FROM python:3.7
MAINTAINER Mathieu Dugre <mail@mdugre.info>

ENV APP_SOURCE_DIR=/opt/certbot/src \
    APP_BUNDLE_DIR=/opt/certbot

WORKDIR $APP_BUNDLE_DIR

COPY . $APP_SOURCE_DIR

EXPOSE 80
EXPOSE 443

VOLUME /etc/letsencrypt /opt/certbot/webroot
WORKDIR /opt/certbot

RUN $APP_SOURCE_DIR/scripts/setup.sh && \
    rm -rf $APP_SOURCE_DIR
