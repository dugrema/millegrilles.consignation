FROM mongo-express:0.49

ENV SRC_FOLDER=/opt/mongo-express/src \
    BUNDLE_FOLDER=/opt/mongo-express/dist \
    MG_CERTS_FOLDER=/usr/local/etc/millegrilles/certs

#MONGODB_ADMINPASSWORD_FILE=/run/secrets/mongo.root.password \

COPY certs $MG_CERTS_FOLDER
COPY ./scripts $SRC_FOLDER/scripts
COPY ./src $SRC_FOLDER

VOLUME /opt/mongo-express/conf

RUN $SRC_FOLDER/scripts/setup.sh

CMD $BUNDLE_FOLDER/run.sh

#node app --url mongodb://mongo:27017/admin?ssl=true
