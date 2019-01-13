#!/usr/bin/env bash

# Remote parameters
GIT_CERT_FOLDER=$HOME/git/MilleGrilles.consignation/certificates

GIT_SCRIPT=git/MilleGrilles.consignation
SCRIPT_PATH=certificates/noeud
SCRIPT_CREATION=creer_cert.sh
#CNF_FILE=openssl-millegrilles-signing.cnf
CERT_SIGNING=millegrilles_signing.cert

preparer_creation_cert_millegrille() {
  SERVER=$1
  NOM_MILLEGRILLE=$2
  DOMAIN_SUFFIX=$3

  SCRIPT_PATH_MILLEGRILLE=certificates/millegrille
  SCRIPT_CERT_MILLEGRILLE=creer_cert_millegrille.sh

  # Uploader le script et l'executer
  ssh $SERVER \
    cd $GIT_SCRIPT \;\
    git pull \;\
    cd $SCRIPT_PATH_MILLEGRILLE \;\
    ./$SCRIPT_CERT_MILLEGRILLE $NOM_MILLEGRILLE $DOMAIN_SUFFIX

  if [ $? -ne 0 ]; then
    echo "Erreur de preparation de la requete de certificat"
    exit 1
  fi
}

preparer_creation_cert_noeud() {
  SERVER=$1
  NOM_MILLEGRILLE=$2
  NOM_NOEUD=$3
  DOMAIN_SUFFIX=$4
  SCRIPT_CREATION_NOEUD=$5

  echo "Preparation cert $NOM_NOEUD.$DOMAIN_SUFFIX sur $SERVER pour MilleGrille $NOM_MILLEGRILLE avec script $SCRIPT_CREATION_NOEUD"

  SCRIPT_PATH_NOEUD=noeud

  # Uploader le script et l'executer
  ssh $SERVER \
    cd $GIT_CERT_FOLDER \;\
    git pull \;\
    cd $SCRIPT_PATH_NOEUD \;\
    ./$SCRIPT_CREATION_NOEUD $NOM_MILLEGRILLE $NOM_NOEUD $DOMAIN_SUFFIX

  if [ $? -ne 0 ]; then
    echo "Erreur de preparation de la requete de certificat"
    exit 1
  fi
}

downloader_csr() {
  SERVER=$1
  SCRIPT_PATH=$2
  NOM_REQUETE=$3

  REMOTE_CSR=$GIT_CERT_FOLDER/${SCRIPT_PATH}/${NOM_REQUETE}.csr

  mkdir -p $HOSTNAME/requests

  ssh $SERVER cat $REMOTE_CSR > $HOSTNAME/requests/$NOM_REQUETE.csr

  if [ $? -ne 0 ]; then
    echo "Erreur de recuperation de la requete de certificat"
    exit 2
  fi
}

signer_certificat() {
  REQUEST_FILE=$1
  CERT_OUTPUT_FILE=$2

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
  NAMED_CERT_FOLDER=$1
  CERT_FILE=$2

  cat $NAMED_CERT_FOLDER/../millegrilles.intermediaire.cert.pem $NAMED_CERT_FOLDER/$CERT_FILE > $NAMED_CERT_FOLDER/$CERT_FILE.fullchain
}

concatener_chaine_noeud() {
  # Fonction qui concatene les certificats de signature et le noeud.
  NAMED_CERT_FOLDER=$1
  CERT_FILE=$2

  cat $NAMED_CERT_FOLDER/../millegrille.cert.pem.fullchain $NAMED_CERT_FOLDER/$CERT_FILE > $NAMED_CERT_FOLDER/$CERT_FILE.fullchain
}

transmettre_certificat() {
  SERVER=$1
  NAMED_CERT_FOLDER=$2
  CERT_FILE=$3

  (cd $NAMED_CERT_FOLDER; tar -cvzf - ${CERT_FILE}*) |
  ssh $SERVER \
    tar -zxC certificates/millegrilles/certs -f -

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
