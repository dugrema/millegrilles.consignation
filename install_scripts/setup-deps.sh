#!/usr/bin/env bash

echo "Dependancies a installer: "
echo " "
echo "1. docker"
echo "2. certbot"
echo " "

installer_certbot_ppa() {
  echo "Debut installation certbot"
  sudo apt update
  sudo apt install -y certbot
  echo "[OK] Certbot installe"
}

installer_docker_snap() {
  echo "Debut installation docker"
  sudo snap install docker
  echo "[OK] docker installe"
}

# Sequence d'Installation

installer_certbot_ppa
installer_docker_snap
