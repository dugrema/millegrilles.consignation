#!/usr/bin/env bash

echo "Dependancies a installer: "
echo " "
echo "1. docker, docker-compose"
echo "2. certbot"
echo " "

installer_certbot_ppa() {
  certbot -h > /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "Debut installation certbot"
    sudo apt update
    sudo apt install -y certbot
    echo "[OK] Certbot installe"
  else
    echo "[INFO] Certbot deja installe"
  fi
}

installer_docker() {
  docker -v > /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "Debut installation docker"
    sudo apt install -y docker.io
    echo "[OK] docker installe"
  else
    echo "[INFO] docker deja installe"
  fi
}

installer_dockercompose() {
  # Noter que le docker-compose installe via apt est trop vieux.
  docker-compose version > /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    apt install curl
    curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod 755 /usr/local/bin/docker-compose
    echo "[OK] docker-compose installe"
  else
    echo "[INFO] docker-compose est deja installe"
  fi
}

# Sequence d'Installation

installer_certbot_ppa
installer_docker
installer_dockercompose
