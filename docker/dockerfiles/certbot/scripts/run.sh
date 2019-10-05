#!/usr/bin/env bash

echo Exection de certbot

LETSENCRYPT_ETC=/etc/letsencrypt
LETSENCRYPT_SITES=$URL_DOMAIN
EMAIL=$EMAIL_ADDRESS

# Verifier si le repertoire /etc/letsencrypt contient deja une configuration
if [ -d $LETSENCRYPT/accounts ]; then
  echo "Verification de renouvellement de certificat"
  CERT_COMMAND='renew'
else
  for SITE in ${LETSENCRYPT_SITES[@]}; do
    SITES="$SITES -d $SITE"
  done

  echo "Creation de nouveaux certificats"
  CERT_COMMAND="certonly --agree-tos -m $EMAIL --work-dir /opt/certbot $SITES"
fi

COMMAND="certbot $CERT_COMMAND -n --webroot -w /opt/certbot/webroot"

# Executer la commande
$COMMAND
