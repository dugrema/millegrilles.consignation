#!/usr/bin/env bash
# Ce script sert a generer des fichiers de configuration pour les
# programmes python et introduire les comptes dans MongoDB.

if [ -z $NOM_MILLEGRILLE ]; then
  echo "Il faut fournir NOM_MILLEGRILLE"
  exit 1
fi

source /opt/millegrilles/etc/variables.txt
CURDATE=`date +%Y%m%d%H%M`

preparer_comptes_mongo() {
  # Les scripts python ont besoin d'avoir des comptes crees dans
  # la base de donnees Mongo. Les mots de passe sont generes aleatoirement
  # et le script de creation de comptes est prepare pour Mongo.

  # Ajouter le nom de la millegrille au script de MongoDB
  preparer_script_mongo

  # Fichier pour le programme de consignation des transactions
  PASSWORD_TRANSACTIONS=`openssl rand -base64 15`
  preparer_configuration $PASSWORDS_PATH/mg.transactions.json $PASSWORD_TRANSACTIONS PWD_TRANSACTION

  # Fichier pour le gestionnaire de domaines
  # Note: le gestionnaire de domaines va se charger de creer les comptes
  # pour chaque domaine specifique.
  PASSWORD_DOMAINES=`openssl rand -base64 15`
  preparer_configuration $PASSWORDS_PATH/mg.mgdomaines.json $PASSWORD_DOMAINES PWD_MGPROCESSUS

  # Programme de backup MongoDB
  PASSWORD_BACKUP=`openssl rand -base64 15`
  preparer_configuration $PASSWORDS_PATH/mg.backup.json $PASSWORD_BACKUP PWD_BACKUP

}

preparer_script_mongo() {
  cp $MONGO_ACCOUNT_SCRIPTS_TEMPLATE $MONGO_ACCOUNT_SCRIPTS
  sed -i 's,NOM_MILLEGRILLE,'"$NOM_MILLEGRILLE"',' $MONGO_ACCOUNT_SCRIPTS

  openssl rand -base64 32 > $PASSWORDS_PATH/mongo.root.password
  openssl rand -base64 32 > $PASSWORDS_PATH/mongoexpress.web.password
  chmod 400 $PASSWORDS_PATH/mongo*
}

preparer_configuration() {
  FICHIER_JSON=$1
  MONGO_PASSWORD=$2
  LABEL_MONGO=$3

  # Fichier config JSON pour python
  cp $TEMPLATE_JSON_FILE $FICHIER_JSON
  sed -i 's,MONGOPASSWORD,'"$MONGO_PASSWORD"',' $FICHIER_JSON
  chmod 400 $FICHIER_JSON

  # Script configuration mongo
  sed -i 's,'"$LABEL_MONGO"','"$MONGO_PASSWORD"',' $MONGO_ACCOUNT_SCRIPTS
}

ajouter_docker_secrets() {
  # Ajoute les fichiers json a docker secrets
  cat $PASSWORDS_PATH/mg.transactions.json | docker secret create mg.$NOM_MILLEGRILLE.transactions.json.$CURDATE -
  cat $PASSWORDS_PATH/mg.mgdomaines.json | docker secret create mg.$NOM_MILLEGRILLE.mgdomaines.json.$CURDATE -
  cat $PASSWORDS_PATH/mg.backup.json | docker secret create mg.$NOM_MILLEGRILLE.backup.json.$CURDATE -
  cat $PASSWORDS_PATH/mongo.root.password | docker secret create mg.$NOM_MILLEGRILLE.mongo_root_password.$CURDATE -
  cat $PASSWORDS_PATH/mongoexpress.web.password | docker secret create mg.$NOM_MILLEGRILLE.mongoexpress_web_password.$CURDATE -
}


# Executer
preparer_comptes_mongo
ajouter_docker_secrets