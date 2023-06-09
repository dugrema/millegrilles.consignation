# FROM mongo-express:0.54
FROM mongo-express:1.0.0-alpha

ENV SRC_FOLDER=/opt/mongo-express/src \
    BUNDLE_FOLDER=/opt/mongo-express/dist \
    ME_CONFIG_MONGODB_ENABLE_ADMIN='true' \
    ME_CONFIG_MONGODB_SSLVALIDATE='true'

#MONGODB_ADMINPASSWORD_FILE=/run/secrets/mongo.root.password \

# COPY certs $MG_CERTS_FOLDER
#COPY ./scripts $SRC_FOLDER/scripts
#COPY ./src $SRC_FOLDER
COPY ./src/config.js /node_modules/mongo-express/

#VOLUME /opt/mongo-express/conf

#RUN $SRC_FOLDER/scripts/setup.sh

# CMD $BUNDLE_FOLDER/run.sh

#node app --url mongodb://mongo:27017/admin?ssl=true
