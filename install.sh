#!/usr/bin/env bash

# Utilisation de sudo pour faire entrer le mot de passe des le debut
sudo echo "Installation de MilleGrilles"
source etc/paths.env

installer_docker() {
  sudo docker info > /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "[INFO] Installation de docker"
    set -e  # Arreter execution sur erreur
    sudo apt install -y docker.io
  else
    echo "[INFO] docker est deja installe"
  fi

  echo "[INFO] Activation du redemarrage automatique de docker"
  sudo systemctl enable docker
}

installer_deployeur() {
  echo "[INFO] Installer deployeur Python et dependances"
  MG_CONSIGNATION=MilleGrilles.consignation.python

  set -e
  mkdir -p tmp/
  cd tmp/

  # Installer MilleGrilles.consignation.python
  if [ ! -d $MG_CONSIGNATION ]; then
    git clone ssh://mathieu@repository.maple.mdugre.info/var/lib/git/$MG_CONSIGNATION
  else
    git -C $MG_CONSIGNATION pull
  fi
  cd $MG_CONSIGNATION
  sudo pip3 install -r requirements.txt
  sudo python3 setup.py install

  # Fix bug 'cannot find abc'
  sudo pip3 uninstall -y bson
  sudo pip3 uninstall -y pymongo
  sudo pip3 install pymongo
  cd ../..

  sudo pip3 install -r requirements.txt
  sudo python3 setup.py install
  echo "[OK] Deployeur Python et dependances installes"
}

preparer_comptes() {
  set -e  # Arreter execution sur erreur
  echo "[INFO] Preparer comptes millegrilles"
  sudo groupadd $MILLEGRILLES_GROUP
  sudo useradd -g $MILLEGRILLES_GROUP $MILLEGRILLES_USER_DEPLOYEUR
  sudo adduser $MILLEGRILLES_USER_DEPLOYEUR docker
  sudo useradd -g $MILLEGRILLES_GROUP $MILLEGRILLES_USER_MAITREDESCLES
  echo "[OK] Comptes millegrilles prets"
}

preparer_opt() {
  set -e  # Arreter execution sur erreur
  echo "[INFO] Preparer $MILLEGRILLES_PATH"
  sudo mkdir -p $MILLEGRILLES_BIN
  sudo mkdir -p $MILLEGRILLES_ETC
  sudo mkdir -p $MILLEGRILLES_CACERT

  sudo chmod -R 2755 $MILLEGRILLES_PATH

  sudo cp -R etc/* $MILLEGRILLES_ETC
  sudo cp -R bin/* $MILLEGRILLES_BIN

  sudo chown -R $MILLEGRILLES_USER_DEPLOYEUR:$MILLEGRILLES_GROUP $MILLEGRILLES_PATH

  echo "[OK] $MILLEGRILLES_PATH pret"
}

# Execution de l'installation
installer() {
  installer_docker
  installer_deployeur
  # preparer_comptes
  preparer_opt
}

creer_millegrille() {
  # Faire un hook vers la creation d'une millegrille si le parametre est inclus
  if [ ! -z $1 ]; then
    NOM_MILLEGRILLE=$1
  fi
  if [ ! -z $NOM_MILLEGRILLE ]; then
    $MILLEGRILLES_BIN/creer_millegrille.sh $NOM_MILLEGRILLE
  else
    echo
    echo "[INFO] Installation de la base millegrilles completee, il faut maintenant creer votre millegrilles"
    echo "[INFO] Utiliser le script: /opt/millegrilles/bin/creer_millegrille.sh NOM_NOUVELLE_MILLEGRILLE"
    echo
  fi
}

installer
creer_millegrille $1