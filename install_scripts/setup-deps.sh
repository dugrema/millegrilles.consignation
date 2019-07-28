#!/usr/bin/env bash

echo "Dependancies a installer: "
echo " "
echo "1. docker, docker-compose"
echo "2. certbot"
echo " "

installer_certbot_ppa() {
  echo "Debut installation certbot"
  sudo apt update
  sudo apt install -y certbot
  echo "[OK] Certbot installe"
}

installer_docker() {
  echo "Debut installation docker"
  sudo apt install -y docker.io
  echo "[OK] docker installe"
}

installer_dockercompose() {
  docker-compose version > /dev/null 2> /dev/null
  if [ $? -ne 1 ]; then
    echo "Tenter d'installer docker-compose"
    curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  fi
}

# Sequence d'Installation

installer_certbot_ppa
installer_docker
installer_dockercompose
