FROM mongo-express:0.49

ENV SRC_FOLDER=/opt/mongo-express/src \
    BUNDLE_FOLDER=/opt/mongo-express/dist

#MONGODB_ADMINPASSWORD_FILE=/run/secrets/mongo.root.password \

COPY ./scripts $SRC_FOLDER/scripts

RUN $SRC_FOLDER/scripts/setup.sh

CMD $BUNDLE_FOLDER/run.sh

#node app --url mongodb://mongo:27017/admin?ssl=true
