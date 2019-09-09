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

    # Si on a une installation debian standard, on install via script
    sudo apt install curl
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    if [ $? -ne 0 ]; then
      # Si echec (e.g. pour RPi), on installe vieille version via pip
      echo "[WARN] Echec d'installtion docker-compose recent, on prend version 1.23"
      pip install docker-compose~=1.23.0
    fi

    sudo chmod 755 /usr/local/bin/docker-compose
    if [ $? -eq 0 ]; then
      echo "[OK] docker-compose installe"
    else
      echo "[FAIL] Echec installation docker-compose"
    fi
  else
    echo "[INFO] docker-compose est deja installe"
  fi
}

# Sequence d'Installation

# installer_certbot_ppa
installer_docker
installer_dockercompose
