#!/usr/bin/env bash

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
    echo -e "\n[FAIL] Parametres globaux requis: NOM_MILLEGRILLE DOMAIN_SUFFIX"
    exit 1
  fi
}

configurer_docker() {
  sudo docker info > /dev/null 2> /dev/null
  PRESENCE_DOCKER=$?
  if [ $PRESENCE_DOCKER -ne 0 ]; then
    echo -e "\n[FAIL] Docker n'est pas detecte, il faut l'installer. Code: $PRESENCE_DOCKER"
    exit 2
  fi
  echo "[OK] Docker est detecte"

  sudo docker node ls > /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "Tenter d'initialiser docker swarm"
    sudo docker swarm init --advertise-addr 127.0.0.1
    if [ $? -ne 0 ]; then
      echo "Erreur initialisation docker swarm"
    fi
  fi

  # Creer le network pour millegrilles
  docker network create -d overlay mg_net
}

preparer_folder_millegrille() {
  echo "Preparer $MG_FOLDER_ROOT"

  sudo mkdir -p $MG_FOLDER_BIN $MG_FOLDER_ETC $MG_FOLDER_CACERTS
  sudo mkdir -p $MG_FOLDER_CERTS $MG_FOLDER_KEYS \
                $PASSWORDS_PATH $MG_FOLDER_LETSENCRYPT
  sudo chmod 750 $MG_FOLDER_KEYS $MG_FOLDER_LETSENCRYPT $PASSWORDS_PATH

  sudo mkdir -p $MG_FOLDER_WEBROOT $MG_FOLDER_WEBCONF

  # Copier scripts (bin)
  sudo cp -r $FOLDER_INSTALL_SRC/install_scripts/bin/* $MG_FOLDER_BIN

  # Copier configuration (etc)
  sudo cp -r $FOLDER_INSTALL_SRC/install_scripts/etc/* $MG_FOLDER_ETC

  # Copier certificats de reference
  sudo cp $FOLDER_INSTALL_SRC/certificates/millegrilles.*.pem $MG_FOLDER_CACERTS
}

installer_certificats_millegrille() {
  echo "Installation des certificats de la MilleGrille dans les secrets docker"
  NOM_MILLEGRILLE=$NOM_MILLEGRILLE \
  DOMAIN_SUFFIX=$DOMAIN_SUFFIX \
  $MG_FOLDER_BIN/setup-manage-certs.sh
}

preparer_comptes_mongo() {
  echo "Preparation des comptes pour MongoDB"
  NOM_MILLEGRILLE=$NOM_MILLEGRILLE \
  $MG_FOLDER_BIN/setup-mongo-accounts.sh
}

# Sequence execution
verifier_parametres
configurer_docker
preparer_folder_millegrille
installer_certificats_millegrille
preparer_comptes_mongo
