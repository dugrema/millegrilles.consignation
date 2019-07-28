#!/usr/bin/env bash

FOLDER_INSTALL_SRC=/home/mathieu/git/MilleGrilles.consignation

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

verifier_presence_docker() {
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
}

preparer_folder_millegrille() {
  MG_FOLDER_ROOT=/opt/millegrilles
  MG_FOLDER_BIN=$MG_FOLDER_ROOT/bin
  MG_FOLDER_ETC=$MG_FOLDER_ROOT/etc
  MG_FOLDER_CACERTS=$MG_FOLDER_ROOT/cacerts
  MG_FOLDER_CERTS=$MG_FOLDER_ROOT/$NOM_MILLEGRILLE/pki/certs
  MG_FOLDER_KEYS=$MG_FOLDER_ROOT/$NOM_MILLEGRILLE/pki/keys
  MG_FOLDER_LETSENCRYPT=$MG_FOLDER_ROOT/$NOM_MILLEGRILLE/pki/letsencrypt
  MG_FOLDER_WEBROOT=$MG_FOLDER_ROOT/nginx/webroot
  MG_FOLDER_WEBCONF=$MG_FOLDER_ROOT/nginx/conf.d
  echo "Preparer $MG_FOLDER_ROOT"

  sudo mkdir -p $MG_FOLDER_BIN $MG_FOLDER_ETC $MG_FOLDER_CACERTS
  sudo mkdir -p $MG_FOLDER_CERTS $MG_FOLDER_KEYS $MG_FOLDER_LETSENCRYPT
  sudo chmod 750 $MG_FOLDER_KEYS $MG_FOLDER_LETSENCRYPT

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

# Sequence execution
verifier_parametres
verifier_presence_docker
preparer_folder_millegrille
installer_certificats_millegrille
