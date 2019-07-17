#!/bin/bash

# Ajouter les certificats dans docker secrets

# chain, fullchain et key
DATE_COURANTE=`date +%Y%m%d`

DOMAIN=$1
OPT_MILLEGRILLES_FOLDER=$2

sudo docker secret create pki.millegrilles.web.fullchain.$DATE_COURANTE \
 $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt/live/www.$DOMAIN/fullchain.pem
sudo docker secret create pki.millegrilles.web.chain.$DATE_COURANTE \
 $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt/live/www.$DOMAIN/chain.pem
sudo docker secret create pki.millegrilles.web.cert.$DATE_COURANTE \
 $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt/live/www.$DOMAIN/cert.pem
sudo docker secret create pki.millegrilles.web.key.$DATE_COURANTE \
 $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt/live/www.$DOMAIN/privkey.pem

