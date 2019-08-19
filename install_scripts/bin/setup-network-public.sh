#!/bin/bash

MESSAGE_AIDE_1='Il manque les parametres: NOM_MILLEGRILLE DOMAIN_SUFFIX'
MESSAGE_AIDE_2='Exemple: letsencrypt_www.sh maple maple.millegrilles.mdugre.info'

NOM_MILLEGRILLE=$1
DOMAIN_SUFFIX=$2

sudo apt -y install miniupnpc letsencrypt

IP=192.168.2.171

# S'assurer qu'on peut acceder a internet via router
upnpc -e "mg-${NOM_MILLEGRILLE}-public-http" -a $IP 80 80 TCP 604800
RESULTHTTP=$?
upnpc -e "mg-${NOM_MILLEGRILLE}-public-https" -a $IP 443 443 TCP 604800
RESULTHTTPS=$?

if [ $RESULTHTTP == 0 ] && [ $RESULTHTTPS == 0]; then
  echo "[OK] Firewall ouvert, port mapping vers $IP active"
else
  echo -e "\n\n[FAIL] Erreur ouverture automatique des ports 80 et 443 sur le routeur"
  echo "Il faut activer redirection des ports 80 et 443 manuellement sur le router vers $IP"
  read -p "Appuyez sur ENTREE lorsque ce sera fait"
fi

# Mettre a jour les labels dans docker, identifier zone public
# sudo docker node update --label-add netzone.public=true ns2

# sleep 30  # Attendre deploiement
# Aller chercher certificats letsencrypt

./letsencrypt_www.sh
