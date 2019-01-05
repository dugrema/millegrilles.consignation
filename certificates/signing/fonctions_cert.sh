#!/usr/bin/env bash

# Remote parameters
GIT_SCRIPT=git/MilleGrilles.consignation
SCRIPT_PATH=certificates/leaf
SCRIPT_CREATION=creer_cert.sh
CNF_FILE=openssl-millegrilles-signing.cnf
CERT_SIGNING=millegrilles_signing.cert

preparer_creation_cert_millegrille() {
  SERVER=$1
  NOM_OU=$2
  DOMAIN_SUFFIX=$3

  # Uploader le script et l'executer
  ssh $SERVER \
    cd $GIT_SCRIPT \;\
    git pull \;\
    cd $SCRIPT_PATH \;\
    ./$SCRIPT_CREATION $NOM_OU $DOMAIN_SUFFIX

  if [ $? -ne 0 ]; then
    echo "Erreur de preparation de la requete de certificat"
    exit 1
  fi
}

preparer_creation_cert_noeud() {
  SERVER=$1
  NOM_OU=$2

  # Uploader le script et l'executer
  ssh $SERVER \
    cd $GIT_SCRIPT \;\
    git pull \;\
    cd $SCRIPT_PATH \;\
    ./$SCRIPT_CREATION $NOM_OU

  if [ $? -ne 0 ]; then
    echo "Erreur de preparation de la requete de certificat"
    exit 1
  fi
}

downloader_csr() {
  SERVER=$1
  NOM_OU=$2

  REMOTE_CSR=$GIT_SCRIPT/${SCRIPT_PATH}/${NOM_OU}.csr

  ssh $SERVER cat $REMOTE_CSR > db/requests/$NOM_OU.csr

  if [ $? -ne 0 ]; then
    echo "Erreur de recuperation de la requete de certificat"
    exit 2
  fi
}

signer_certificat() {
  NOM_OU=$1
  REQUEST_FILE=$2
  CERT_OUTPUT_FILE=$3

  openssl ca -config $CNF_FILE \
          -policy signing_policy \
          -extensions signing_req \
          -out ${CERT_OUTPUT_FILE} \
          -infiles ${REQUEST_FILE}

  if [ $? -ne 0 ]; then
    echo "Erreur de signature du certificat"
    exit 3
  fi
}

concatener_chaine() {
  # Fonction qui concatene le certificat de signature et le leaf.
  CERT_FILE=$1
  
  csplit -f tmp-cert- $CERT_FILE '/-----BEGIN CERTIFICATE-----/' '{*}'
  cat $CERT_SIGNING tmp-cert-01 > $CERT_FILE.fullchain
  rm tmp-cert*
}

transmettre_certificat() {
  SERVER=$1
  CERT_FILE=$2

  cat $CERT_FILE |
  ssh $SERVER \
    cat - \> certificates/millegrilles/certs/$NOM_OU.cert.pem

  if [ $? -ne 0 ]; then
    echo "Erreur d'upload du certificat $CERT_FILE"
    exit 4
  fi
}

# Creer et signer un nouveau certificat
# preparer_creation $SERVER $NOM_OU
# downloader_csr $SERVER $NOM_OU
# signer_certificat $NOM_OU db/requests/$NOM_OU.csr db/named_certs/$NOM_OU.cert.pem
# transmettre_certificat $SERVER db/named_certs/$NOM_OU.cert.pem
