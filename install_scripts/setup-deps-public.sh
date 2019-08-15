#!/usr/bin/env bash

echo "Dependancies a installer pour noeud public: "
echo " "
echo "1. docker"
echo "2. certbot"
echo "3. miniupnpc"
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

installer_miniupnpc() {
  upnpc -v > /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "Debut installation miniupnpc"
    sudo apt install -y miniupnpc
    echo "[OK] miniupnpc installe"
  else
    echo "[INFO] miniupnpc deja installe"
  fi
}

# Sequence d'Installation

# installer_certbot_ppa
installer_docker
installer_dockercompose
