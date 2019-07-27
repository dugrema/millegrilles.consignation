#!/usr/bin/env bash

NOM_MILLEGRILLE=$1

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
  if [ -z $NOM_MILLEGRILLE ]; then
    echo -e "\n[FAIL] Parametres requis: NOM_MILLEGRILLE"
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

  # Copier certificats de reference
  sudo cp $FOLDER_INSTALL_SRC/certificates/millegrilles.*.pem $MG_FOLDER_CACERTS

}

# Sequence execution
verifier_parametres
verifier_presence_docker
preparer_folder_millegrille
