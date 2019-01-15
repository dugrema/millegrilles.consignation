FROM debian:stretch
MAINTAINER Mathieu Dugre <mail@mdugre.info>

#Inspire de https://github.com/jshimko/meteor-launchpad/blob/master/Dockerfile

RUN groupadd -r node && useradd -m -g node node

# Gosu
# build directories
ENV GOSU_VERSION=1.10 \
    APP_SOURCE_DIR=/opt/meteor/src \
    APP_BUNDLE_DIR=/opt/meteor/dist \
    BUILD_SCRIPTS_DIR=/opt/build_scripts

RUN mkdir -p $APP_SOURCE_DIR && \
    mkdir -p $APP_BUNDLE_DIR/bundle

# Add entrypoint and build scripts
COPY scripts $BUILD_SCRIPTS_DIR
RUN chmod -R 750 $BUILD_SCRIPTS_DIR

WORKDIR $APP_BUNDLE_DIR/bundle

# Node.JS et Meteor - les versions doivent aller ensemble
# Meteor est sensible, faire: meteor --version, puis meteor node --version
# sur la machine de developpement
ENV NODE_VERSION=8.11.4 \
    METEOR_VERSION=1.8

RUN \
  cd $APP_SOURCE_DIR && \
  $BUILD_SCRIPTS_DIR/install-deps.sh && \
  $BUILD_SCRIPTS_DIR/install-node.sh && \
  $BUILD_SCRIPTS_DIR/install-meteor.sh && \
  $BUILD_SCRIPTS_DIR/post-install-cleanup.sh 

# Define all --build-arg options
ONBUILD ARG APT_GET_INSTALL
ONBUILD ENV APT_GET_INSTALL $APT_GET_INSTALL

ONBUILD ARG NPM_TOKEN
ONBUILD ENV NPM_TOKEN $NPM_TOKEN

# Node flags for the Meteor build tool
ONBUILD ARG TOOL_NODE_FLAGS
ONBUILD ENV TOOL_NODE_FLAGS $TOOL_NODE_FLAGS

# optionally custom apt dependencies at app build time
ONBUILD RUN if [ "$APT_GET_INSTALL" ]; then apt-get update && apt-get install -y $APT_GET_INSTALL; fi

# copy the app to the container
ONBUILD COPY . $APP_SOURCE_DIR

# install all dependencies, build app, clean up
ONBUILD RUN cd $APP_SOURCE_DIR && \
  $BUILD_SCRIPTS_DIR/build-meteor.sh && \
  $BUILD_SCRIPTS_DIR/post-build-cleanup.sh

# Default values for Meteor environment variables
ENV ROOT_URL=http://dev2.maple.mdugre.info \
    MONGO_URL=mongodb://coupdoeil:p1234@127.0.1.1:27017/mg-sansnom \
    PORT=3000

EXPOSE 3000

# start the app
ENTRYPOINT ["./entrypoint.sh"]
CMD ["node", "main.js"]
