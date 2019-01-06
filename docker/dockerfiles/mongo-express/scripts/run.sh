#!/bin/bash

# Charger le mot de passe root en memoire
if [ ! -z $MONGODB_ADMINPASSWORD_FILE ]; then
  ME_CONFIG_MONGODB_ADMINPASSWORD=`cat $MONGODB_ADMINPASSWORD_FILE`
  export ME_CONFIG_MONGODB_ADMINPASSWORD
  echo "Mot de passe ME_CONFIG_MONGODB_ADMINPASSWORD charge"
fi

if [ ! -z $ME_CONFIG_BASICAUTH_PASSWORD_FILE ]; then
  ME_CONFIG_BASICAUTH_PASSWORD=`cat $ME_CONFIG_BASICAUTH_PASSWORD_FILE`
  export ME_CONFIG_BASICAUTH_PASSWORD_FILE
  echo "Mot de passe ME_CONFIG_BASICAUTH_PASSWORD charge"
fi

# if [ -z $ME_CONFIG_MONGODB_URL ]; then
#   echo "Il faut fournir le URL de connexion a mongo: ME_CONFIG_MONGODB_URL"
#   exit 1
# fi

echo "Demarrer mongo-express"
# mongodb://mongo:27017/admin?ssl=true
#node app --url $ME_CONFIG_MONGODB_URL
node app
