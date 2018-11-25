FROM nginx:1.15
MAINTAINER Mathieu Dugre <mail@mdugre.info>

ENV APP_SOURCE_DIR=/opt/nginx/src
ENV APP_BUNDLE_DIR=/opt/nginx/dist

WORKDIR $APP_BUNDLE_DIR

COPY . $APP_SOURCE_DIR

RUN http_proxy=http://192.168.1.28:8000 && export http_proxy && \
    $APP_SOURCE_DIR/scripts/setup.sh && \
    rm -rf $APP_SOURCE_DIR
    
CMD ["/opt/nginx/dist/run.sh"]
