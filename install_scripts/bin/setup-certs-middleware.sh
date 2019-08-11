#!/usr/bin/env bash

# Parametres obligatoires
if [ -z $NOM_MILLEGRILLE ] || [ -z $DOMAIN_SUFFIX ]; then
  echo "Les parametres NOM_MILLEGRILLE et DOMAIN_SUFFIX doivent etre definis globalement"
  exit 1
fi

# Parametres optionnel
if [ -z $CURDATE ]; then
  CURDATE=`date +%Y%m%d%H%M`
fi

source /opt/millegrilles/etc/variables.txt

importer_dans_docker() {
  CERT_MIDDLEWARE=$CERT_PATH/${NOM_MILLEGRILLE}_middleware_${CURDATE}.cert.pem
  CLE_MIDDLEWARE=$PRIVATE_PATH/${NOM_MILLEGRILLE}_middleware_${CURDATE}.key.pem

  # Certs root
  cat $CA_CERT $MG_CERT | docker secret create pki.$NOM_MILLEGRILLE.millegrilles.ssl.CAchain.$CURDATE -

  # Cles middleware
  cat $CERT_MIDDLEWARE | docker secret create pki.$NOM_MILLEGRILLE.middleware.ssl.cert.$CURDATE -
  cat $CLE_MIDDLEWARE | docker secret create pki.$NOM_MILLEGRILLE.middleware.ssl.key.$CURDATE -
  cat $CLE_MIDDLEWARE $CERT_MIDDLEWARE | docker secret create pki.$NOM_MILLEGRILLE.middleware.ssl.key_cert.$CURDATE -
  cat $CA_CERT $MG_CERT $CERT_MIDDLEWARE | docker secret create pki.$NOM_MILLEGRILLE.middleware.ssl.fullchain.$CURDATE -
}

# Sequence
sequence_chargement() {
  # On ne regenere pas la cle CA si elle existe deja.
  if [ ! -f $CA_KEY ]; then
    echo "Generer un certificat self-signed"
    creer_ssrootcert \
      ${NOM_MILLEGRILLE}_ssroot \
      $ETC_FOLDER/openssl-rootca.cnf
  fi

  # On ne regenere pas la cle MilleGrille (CA) si elle existe deja,
  # sauf si le flag RENOUV_MILLEGRILLE est present
  if [ ! -f $CERT_PATH/${NOM_MILLEGRILLE}_millegrille.cert.pem ] || [ ! -z $RENOUV_MILLEGRILLE ]; then
    echo "Generer un certificat MilleGrille (CA)"
    creer_certca_millegrille \
      ${NOM_MILLEGRILLE}_millegrille \
      $ETC_FOLDER/openssl-millegrille.cnf
  fi

  # Creer le noeud middleware
  echo "Generer un certificat de noeud Middleware"
  creer_cert_noeud \
   ${NOM_MILLEGRILLE}_middleware \
    $ETC_FOLDER/openssl-millegrille-middleware.cnf

  importer_dans_docker
}

# Executer
sequence_chargement
