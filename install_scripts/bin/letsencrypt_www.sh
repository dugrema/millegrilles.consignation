#!/usr/bin/env bash

MESSAGE_AIDE_1='Il manque les parametres: NOM_MILLEGRILLE DOMAIN_SUFFIX'
MESSAGE_AIDE_2='Exemple: letsencrypt_www.sh maple maple.millegrilles.mdugre.info'

NOM_MILLEGRILLE=$1
DOMAIN_SUFFIX=$2

# Importer variables d'environnement MilleGrilles
source /opt/millegrilles/etc/variables.txt

LISTE_APPS=( www coupdoeil )
for NOM_DOMAINE in ${LISTE_APPS[@]}; do
  NOMS_DOMAINES="$NOMS_DOMAINES -d $NOM_DOMAINE.$DOMAIN_SUFFIX"
done

if [ -z $2 ]; then
  echo $MESSAGE_AIDE_1
  echo $MESSAGE_AIDE_2
  exit 1
fi

echo NOMS_DOMAINES:  $NOMS_DOMAINES
echo MG_FOLDER_LETSENCRYPT: $MG_FOLDER_LETSENCRYPT
echo MG_FOLDER_NGINX_WWW_PUBLIC: $MG_FOLDER_NGINX_WWW_PUBLIC

if [ ! -d $MG_FOLDER_LETSENCRYPT/live ]; then
 sudo certbot certonly \
   --config-dir $MG_FOLDER_LETSENCRYPT \
   --expand --webroot -w $MG_FOLDER_NGINX_WWW_PUBLIC \
   $NOMS_DOMAINES
fi

# sudo certbot renew -n \
# --config-dir $MG_FOLDER_LETSENCRYPT \
# --expand --webroot -w $REPERTOIRE_NGINX \
# --post-hook "./letsencrypt_renewhook.sh $DOMAIN $OPT_MILLEGRILLES_FOLDER"
