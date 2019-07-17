#!/bin/sh

MESSAGE_AIDE_1='Il manque les parametres: DOMAIN OPT_MILLEGRILLES_FOLDER'
MESSAGE_AIDE_2='Exemple: letsencrypt_www.sh maple.millegrilles.mdugre.info /opt/millegrilles/maple'

if [ -z $2 ]; then
  echo $MESSAGE_AIDE_1
  echo $MESSAGE_AIDE_2
  exit 1
fi

DOMAIN=$1
OPT_MILLEGRILLES_FOLDER=$2

# sudo certbot certonly --dry-run --must-staple --staple-ocsp \
# --config-dir $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt \
# --expand --webroot -w $OPT_MILLEGRILLES_FOLDER/nginx/webroot \
# -d www.$DOMAIN -d coupdoeil.$DOMAIN

sudo certbot renew -n --must-staple --staple-ocsp \
--config-dir $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt \
--expand --webroot -w $OPT_MILLEGRILLES_FOLDER/nginx/webroot \
--post-hook "./letsencrypt_renewhook.sh $1 $2"

# RESULT_CB=$?
# Pour renew, utiliser commande renew et flag -n pour non-interactif

# if [ $RESULT_CB -eq 0 ]; then
#   # Ajouter les certificats dans docker secrets
#   # chain, fullchain et key
#   DATE_COURANTE=`date +%Y%m%d`
#   sudo docker secret create pki.millegrilles.web.fullchain.$DATE_COURANTE \
#     $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt/live/www.$DOMAIN/fullchain.pem
#   sudo docker secret create pki.millegrilles.web.chain.$DATE_COURANTE \
#     $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt/live/www.$DOMAIN/chain.pem
#   sudo docker secret create pki.millegrilles.web.cert.$DATE_COURANTE \
#     $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt/live/www.$DOMAIN/cert.pem
#   sudo docker secret create pki.millegrilles.web.key.$DATE_COURANTE \
#     $OPT_MILLEGRILLES_FOLDER/pki/letsencrypt/live/www.$DOMAIN/privkey.pem
# fi
