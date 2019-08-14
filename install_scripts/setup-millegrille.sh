#!/usr/bin/env bash

# set -e  # Force la sortie sur tout exit

source etc/variables.txt

echo "Installation MilleGrille"
echo " "
echo "Ceci est un script pour faire le setup d'une nouvelle MilleGrille"
echo " "
echo "Dependances: "
echo "docker"
echo "certbot"
echo " "
echo "Etapes d'installation de la MilleGrille"
echo "1. Generer le certificat de MilleGrille"
echo "2. Generer le certificat de middleware"
echo "3. Mettre tous les secrets dans docker"

verifier_parametres() {
  if [ -z $NOM_MILLEGRILLE ] || [ -z $DOMAIN_SUFFIX ]; then
    echo -e "\n[FAIL] Parametres globaux requis: NOM_MILLEGRILLE DOMAIN_SUFFIX\n"
    echo -e "Noter que DOMAIN_SUFFIX peut etre 'local' pour avoir un mode local uniquement."
    exit 1
  else
    export URL_DOMAIN=$NOM_MILLEGRILLE.$DOMAIN_SUFFIX
    echo -e "\n[OK] Parametres corrects: NOM_MILLEGRILLE=$NOM_MILLEGRILLE, DOMAIN_SUFFIX=$DOMAIN_SUFFIX"
    echo "L'URL de la MilleGrille sera: https://$URL_DOMAIN"
  fi
}

configurer_docker() {
  # Genere une swarm docker sur localhost (127.0.0.1)

  sudo docker info > /dev/null 2> /dev/null
  PRESENCE_DOCKER=$?
  if [ $PRESENCE_DOCKER -ne 0 ]; then
    echo -e "\n[FAIL] Docker n'est pas detecte, il faut l'installer. Code: $PRESENCE_DOCKER"
    exit 2
  fi
  echo "[OK] Docker est detecte"

  sudo docker node ls > /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "\n[FAIL] Tenter d'initialiser docker swarm"
    sudo docker swarm init --advertise-addr 127.0.0.1
    if [ $? -ne 0 ]; then
      echo "\n[FAIL] Erreur initialisation docker swarm"
      exit 10
    fi
  fi

  # Creer le network pour millegrilles (variable NET_NAME)
  sudo docker network create -d overlay --attachable $NET_NAME
  if [ $? != 0 ]; then
    sudo docker network ls | grep $NET_NAME
    if [ $? != 0 ]; then
      echo "\n[FAIL] Erreur d'ajout de l'interface reseau $NET_NAME. Vous n'avez pas acces a docker"
      exit 11
    fi
  fi

  # Ajouter les labels utilises pour les services
  NODE=`hostname`
  sudo docker node update --label-add netzone.private=true $NODE

  # docker node update --label-add netzone.public=true $NODE
  # Inserer les labels pour laisser les serveurs Mongo et MQ demarrer
  # Va permettre de configurer les comptes de services avant les autres modules
  sudo docker node update --label-add millegrilles.database=true $NODE
  sudo docker node update --label-add millegrilles.mq=true $NODE

  echo "[OK] configurer_docker() Complete avec succes"
}

ajouter_labels_internes_docker() {
  sudo docker node update --label-add millegrilles.nginx=true $NODE
  sudo docker node update --label-add millegrilles.python=true $NODE
  sudo docker node update --label-add millegrilles.domaines=true $NODE
  sudo docker node update --label-add millegrilles.consoles=true $NODE
  sudo docker node update --label-add millegrilles.coupdoeil=true $NODE
  sudo docker node update --label-add millegrilles.consignationfichiers=true $NODE
}

preparer_folder_millegrille() {
  echo "[INFO] Preparer $MG_FOLDER_ROOT"

  sudo mkdir -p $MG_FOLDER_BIN $MG_FOLDER_ETC $MG_FOLDER_CACERTS
  sudo mkdir -p $MG_FOLDER_CERTS $MG_FOLDER_KEYS \
                $PASSWORDS_PATH $MG_FOLDER_LETSENCRYPT \
                $MG_FOLDER_NGINX_WWW_LOCAL $MG_FOLDER_NGINX_WWW_PUBLIC
  sudo chmod 750 $MG_FOLDER_KEYS $MG_FOLDER_LETSENCRYPT $PASSWORDS_PATH \
                 $MG_FOLDER_NGINX_WWW_LOCAL $MG_FOLDER_NGINX_WWW_PUBLIC

  # Copier scripts (bin)
  sudo cp -r $FOLDER_INSTALL_SRC/install_scripts/bin/* $MG_FOLDER_BIN

  # Copier configuration (etc)
  sudo cp -r $FOLDER_INSTALL_SRC/install_scripts/etc/* $MG_FOLDER_ETC

  # Copier certificats de reference
  sudo cp $FOLDER_INSTALL_SRC/certificates/millegrilles.*.pem $MG_FOLDER_CACERTS

  echo -e "NOM_MILLEGRILLE=$NOM_MILLEGRILLE\nDOMAIN_SUFFIX=$DOMAIN_SUFFIX" | \
    sudo tee $MG_FOLDER_ETC/${NOM_MILLEGRILLE}.conf

  echo "[OK] preparer_folder_millegrille() Complete avec succes"
}

installer_certificats_millegrille() {
  echo "[INFO] Installation des certificats de la MilleGrille dans les secrets docker"

  # Changement de repertoire vers les scripts ... trouver meilleure approche
  $MG_FOLDER_BIN/setup-certs-ca.sh
  $MG_FOLDER_BIN/setup-certs-middleware.sh
  echo "[OK] installer_certificats_millegrille() Complete avec succes"
}

preparer_comptes_mongo() {
  echo "[INFO] Preparation des comptes pour MongoDB"
  NOM_MILLEGRILLE=$NOM_MILLEGRILLE \
  $MG_FOLDER_BIN/setup-mongo-accounts.sh
}

preparer_stack_docker() {
  echo Preparer stack docker
  CURRUSER=`whoami`
  sudo mkdir -p $MG_FOLDER_DOCKER_CONF
  sudo chown $CURRUSER:root $MG_FOLDER_DOCKER_CONF
  cp $MG_FOLDER_ETC/docker/* $MG_FOLDER_ETC/docker/.env $MG_FOLDER_DOCKER_CONF

  CERTS_DATE=`cat $CERT_PATH/${NOM_MILLEGRILLE}_middleware_latest.txt` \
  PASSWORDS_DATE=`cat $CERT_PATH/${NOM_MILLEGRILLE}_passwords_latest.txt` \
  WEB_DATE=`cat $CERT_PATH/${NOM_MILLEGRILLE}_web_latest.txt` \
  envsubst < $MG_FOLDER_ETC/docker/template.env > $MG_FOLDER_DOCKER_CONF/$NOM_MILLEGRILLE.env

  cd $MG_FOLDER_DOCKER_CONF
  echo "Repertoire courant $PWD"
  source $NOM_MILLEGRILLE.env
  export $(cut -d= -f1 $NOM_MILLEGRILLE.env)
  docker-compose config > $NOM_MILLEGRILLE.yml

  echo "[INFO] Fichier de configuration de la stack genere, demarrage du deploiement"
  sudo docker stack deploy -c $NOM_MILLEGRILLE.yml millegrille-$NOM_MILLEGRILLE
}

preparer_repertoires_mounts() {
  sudo mkdir -p \
    $MG_FOLDER_MONGO_SHARED $MG_FOLDER_MONGO_DATA \
    $MG_FOLDER_MQ_ACCOUNTS \
    $MG_FOLDER_CONSIGNATION

  CURRUSER=`whoami`
  sudo chown -R $CURRUSER:root $MG_FOLDER_MOUNTS

  sudo chown -R $CURRUSER:root $MG_FOLDER_MOUNTS
  chmod -R 750 $MG_FOLDER_MOUNTS

  echo '[OK] Repertoires sous $MG_FOLDER_MOUNTS prets'
}

preparer_comptes_mq() {
  echo "[INFO] Utilisation cert middleware pour creer compte RabbitMQ : $MIDDLEWARE_CERT"
  certificat_parser_mq $MIDDLEWARE_CERT
  echo "[INFO] Noeud type $TYPE_NOEUD: $SUBJECT_MQ"

  echo "middleware_init;$SUBJECT_MQ;$NOM_MILLEGRILLE;$TYPE_NOEUD" >> $MQ_NEW_USERS_FILE
}

certificat_parser_mq() {
  FICHIER_CERT=$1
  SUBJECT=`openssl x509 -noout -subject -in $FICHIER_CERT`
  SUBJECT=(`echo $SUBJECT | sed s/subject=//g | sed s/' '//g | sed s/,/' '/g `)

  echo 1 $SUBJECT

  declare -A cert_fields
  for field in "${SUBJECT[@]}"; do
    field=(`echo $field | sed s/=/' '/g`)
    cert_fields[${field[0]}]=${field[1]}
  done

  # Retourne les valeurs pour nom usager et type (middleware ou noeud)
  # Le type est dans le champ OU
  TYPE_NOEUD=`echo ${cert_fields['OU']} | awk '{print tolower($0)}'`
  SUBJECT_MQ="CN=${cert_fields['CN']},OU=${cert_fields['OU']},O=${cert_fields['O']},L=${cert_fields['L']},ST=${cert_fields['ST']},C=${cert_fields['C']}"
}

inserer_comptes_mongo() {
  # Fabrique un mapping vers le reseau overlay mg_net (permet de trouver le
  # serveur mongo), de /opt/millgrilles/bin et /opt/millegrilles/NOM_MILLEGRILLE.
  # Execute le script setup-mongo-js.sh qui va executer le script avec
  # mots de passes dans /opt/millegrilles/NOM_MILLEGRILLE/mounts/mongo-shared.

  sudo docker container run --rm -it \
         -e MONGOHOST=mongo --network $NET_NAME \
         -e NOM_MILLEGRILLE=$NOM_MILLEGRILLE \
         -v $MG_FOLDER_BIN:$MG_FOLDER_BIN \
         -v $MG_FOLDER_MILLEGRILLE:$MG_FOLDER_MILLEGRILLE \
         mongo:4.0 \
         $MG_FOLDER_BIN/setup-mongo-js.sh
}

executer() {
  # Sequence execution
  verifier_parametres

  export $NOM_MILLEGRILLE $DOMAIN_SUFFIX

  configurer_docker
  preparer_folder_millegrille
  installer_certificats_millegrille
  preparer_repertoires_mounts
  preparer_comptes_mongo
  preparer_comptes_mq
  preparer_stack_docker

  echo "[INFO] Attendre que les services MongoDB et RabbitMQ soient actifs pour configurer les comptes de services"
  sleep 60  # Fixme: Trouver une facon de voir que MongoDB est deploye
  inserer_comptes_mongo

  echo "[INFO] Activer les autres services dans Docker"
  ajouter_labels_internes_docker
}

executer
