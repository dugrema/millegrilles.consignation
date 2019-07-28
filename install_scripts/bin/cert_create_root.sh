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

HOSTNAME=`hostname --fqdn`

PRIVATE_PATH=/opt/millegrilles/$NOM_MILLEGRILLE/pki/keys
CERT_PATH=/opt/millegrilles/$NOM_MILLEGRILLE/pki/certs
DBS_PATH=/opt/millegrilles/$NOM_MILLEGRILLE/pki/dbs
CA_KEY=$PRIVATE_PATH/${NOM_MILLEGRILLE}_ssroot.key.pem
ETC_FOLDER=../etc
SSROOT_PASSWD_FILE=$ETC_FOLDER/cert_ssroot_password.txt
MILLEGRILLE_PASSWD_FILE=$ETC_FOLDER/cert_millegrille_password.txt

creer_ssrootcert() {
  NOMCLE=$1
  CNF_FILE=$2

  SUBJECT="/C=CA/ST=Ontario/L=Russell/O=MilleGrilles/OU=SSRoot/CN=ssroot.millegrilles.com/emailAddress=ssroot@millegrilles.com"

  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  SSCERT=$CERT_PATH/${NOMCLE}_${CURDATE}.cert.pem
  let "DAYS=365 * 10"  # 10 ans

  if [ -f $KEY ]; then
    echo "Cle $KEY existe deja - on abandonne"
    exit 1
  fi

  openssl req -x509 -config $CNF_FILE \
          -sha512 -days $DAYS \
          -out $SSCERT -outform PEM \
          -keyout $KEY -keyform PEM \
          -subj $SUBJECT \
          -passout file:$ETC_FOLDER/$SSROOT_PASSWD_FILE

  if [ $? -ne 0 ]; then
    echo "Erreur openssl creer_ssrootcert()"
    exit 2
  fi

  # Creer lien generique pour la cle root
  chmod 400 $KEY
  chmod 444 $SSCERT
  ln -sf $KEY $CA_KEY
  ln -sf $SSCERT $CERT_PATH/${NOMCLE}.cert.pem

  if [ ! -d $DBS_PATH/$HOSTNAME ]; then
    # Preparer le repertoire de DB pour signature
    mkdir -p $DBS_PATH/root/certs
    touch $DBS_PATH/root/index.txt
    touch $DBS_PATH/root/index.txt.attr
    echo "01" > $DBS_PATH/root/serial.txt
  fi

}

creer_certca_millegrille() {
  NOMCLE=$1
  CNF_FILE=$2

  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem

  SUBJECT="/C=CA/ST=Ontario/L=Russell/O=MilleGrilles/OU=MilleGrille/CN=$HOSTNAME/emailAddress=$NOM_MILLEGRILLE@millegrilles.com"

  if [ -f $KEY ]; then
    echo "Cle $KEY existe deja - on abandonne"
  fi

  HOSTNAME=$HOSTNAME DOMAIN_SUFFIX=$DOMAIN_SUFFIX \
  openssl req \
          -config $CNF_FILE \
          -newkey rsa:4096 -sha512 \
          -out $REQ -outform PEM \
          -keyout $KEY -keyform PEM \
          -subj $SUBJECT \
          -passout file:$ETC_FOLDER/$MILLEGRILLE_PASSWD_FILE
  if [ $? -ne 0 ]; then
    echo "Erreur openssl creer_certca_millegrille()"
    exit 1
  fi

  signer_cert_par_ssroot $NOMCLE ../etc/openssl-rootca.cnf

  # Creer lien generique pour la cle root
  chmod 400 $KEY
  ln -sf $KEY $CA_KEY
  ln -sf $CERT $CERT_PATH/${NOMCLE}.cert.pem

  if [ ! -d $DBS_PATH/$HOSTNAME ]; then
    mkdir -p $DBS_PATH/$HOSTNAME/certs
    touch $DBS_PATH/$HOSTNAME/index.txt
    touch $DBS_PATH/$HOSTNAME/index.txt.attr
    echo "01" > $DBS_PATH/$HOSTNAME/serial.txt
  fi

}

signer_cert_par_ssroot() {
  NOMCLE=$1
  CNF_FILE=$2

  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem
  CERT=$CERT_PATH/${NOMCLE}_${CURDATE}.cert.pem

  openssl ca -config $CNF_FILE \
          -policy signing_policy \
          -extensions signing_req \
          -keyfile $CA_KEY -keyform PEM \
          -out $CERT \
          -passin file:$ETC_FOLDER/$SSROOT_PASSWD_FILE \
          -batch \
          -infiles $REQ
}

creer_cert_noeud() {
  NOMCLE=$1
  CNF_FILE=$2

  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem

  SUBJECT="/C=CA/ST=Ontario/L=Russell/O=MilleGrilles/OU=Noeud/CN=$HOSTNAME/emailAddress=$NOM_MILLEGRILLE@millegrilles.com"

  if [ -f $KEY ]; then
    echo "Cle $KEY existe deja - on abandonne"
  fi

  HOSTNAME=$HOSTNAME DOMAIN_SUFFIX=$DOMAIN_SUFFIX \
  openssl req \
          -config $CNF_FILE \
          -newkey rsa:2048 -sha512 \
          -out $REQ -outform PEM \
          -keyout $KEY -keyform PEM \
          -subj $SUBJECT \
          -nodes

  if [ $? -ne 0 ]; then
    echo "Erreur openssl creer_cert_noeud()"
    exit 1
  fi

  HOSTNAME=$HOSTNAME DOMAIN_SUFFIX=$DOMAIN_SUFFIX \
  signer_cert_par_millegrille $NOMCLE ../etc/openssl-millegrille.cnf

}

signer_cert_par_millegrille() {
  NOMCLE=$1
  CNF_FILE=$2

  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem
  CERT=$CERT_PATH/${NOMCLE}_${CURDATE}.cert.pem

  openssl ca -config $CNF_FILE \
          -policy signing_policy \
          -extensions signing_req \
          -keyfile $CA_KEY -keyform PEM \
          -out $CERT \
          -passin file:$ETC_FOLDER/$MILLEGRILLE_PASSWD_FILE \
          -batch \
          -infiles $REQ
}

importer_dans_docker() {
  CERT_MIDDLEWARE=$CERT_PATH/${NOM_MILLEGRILLE}_middleware_${CURDATE}.cert.pem
  CLE_MIDDLEWARE=$PRIVATE_PATH/${NOM_MILLEGRILLE}_middleware_${CURDATE}.key.pem
  CERT_MILLEGRILLE=$CERT_PATH/${NOM_MILLEGRILLE}_millegrille_${CURDATE}.cert.pem
  CERT_SSROOT=$CERT_PATH/${NOM_MILLEGRILLE}_ssroot_${CURDATE}.cert.pem
  docker secret create pki.millegrilles.ssl.cert $CERT_MIDDLEWARE
  docker secret create pki.millegrilles.ssl.key $CLE_MIDDLEWARE
  cat $CLE_MIDDLEWARE $CERT_MIDDLEWARE | docker secret create pki.millegrilles.ssl.key_cert -
  cat $CERT_SSROOT $CERT_MILLEGRILLE | docker secret create pki.millegrilles.ssl.CAchain -
}

# Sequence
#creer_ssrootcert \
#  ${NOM_MILLEGRILLE}_ssroot \
#  ../etc/openssl-rootca.cnf

#creer_certca_millegrille \
#  ${NOM_MILLEGRILLE}_millegrille \
#  ../etc/openssl-millegrille.cnf

# Creer le noeud middleware
#creer_cert_noeud \
# ${NOM_MILLEGRILLE}_middleware \
#  ../etc/openssl-millegrille-middleware.cnf

importer_dans_docker
