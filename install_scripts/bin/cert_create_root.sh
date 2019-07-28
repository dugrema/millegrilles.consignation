#!/usr/bin/env bash
if [ -z $NOM_MILLEGRILLE ]; then
  echo "Le parametre NOM_MILLEGRILLE doit etre definie globalement"
  exit 1
fi

PRIVATE_PATH=/opt/millegrilles/$NOM_MILLEGRILLE/pki/keys
CERT_PATH=/opt/millegrilles/$NOM_MILLEGRILLE/pki/certs
DBS_PATH=/opt/millegrilles/$NOM_MILLEGRILLE/pki/dbs
CA_KEY=$PRIVATE_PATH/${NOM_MILLEGRILLE}_ssroot.key.pem

creer_ssrootcert() {
  NOMCLE=$1
  CNF_FILE=$2

  SUBJECT="/C=CA/ST=Ontario/L=Russell/O=MilleGrilles/OU=SSRoot/CN=ssroot.millegrilles.com/emailAddress=ssroot@millegrilles.com"

  CURDATE=`date +%Y%m%d%H%M`
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
          -subj $SUBJECT

  if [ $? -ne 0 ]; then
    echo "Erreur openssl creer_ssrootcert()"
    exit 2
  fi

  # Creer lien generique pour la cle root
  chmod 400 $KEY
  chmod 444 $SSCERT
  ln -s $KEY $CA_KEY
  ln -s $SSCERT $CERT_PATH/${NOMCLE}.cert.pem

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

  CURDATE=`date +%Y%m%d%H%M`
  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem
  HOSTNAME=`hostname --fqdn`

  SUBJECT="/C=CA/ST=Ontario/L=Russell/O=MilleGrilles/OU=MilleGrille/CN=$HOSTNAME/emailAddress=$NOM_MILLEGRILLE@millegrilles.com"

  if [ -f $KEY ]; then
    echo "Cle $KEY existe deja - on abandonne"
  fi

  HOSTNAME=$HOSTNAME DOMAIN_SUFFIX=com \
  openssl req \
          -config $CNF_FILE \
          -newkey rsa:4096 -sha512 \
          -out $REQ -outform PEM \
          -keyout $KEY -keyform PEM

  if [ $? -ne 0 ]; then
    echo "Erreur openssl creer_certca_millegrille()"
    exit 1
  fi

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

  CURDATE=`date +%Y%m%d`
  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem
  CERT=$CERT_PATH/${NOMCLE}_${CURDATE}.cert.pem

  openssl ca -config $CNF_FILE \
          -policy signing_policy \
          -extensions signing_req \
          -keyfile $CA_KEY -keyform PEM \
          -out $CERT \
          -infiles $REQ
}

# Sequence
creer_ssrootcert \
  ${NOM_MILLEGRILLE}_ssroot \
  ../etc/openssl-rootca.cnf

#creer_certca_millegrille \
#  ${NOM_MILLEGRILLE}_millegrille \
#  ../etc/openssl-millegrille.cnf

#signer_cert_par_ssroot \
#  ${NOM_MILLEGRILLE}_millegrille \
#  ../etc/openssl-rootca.cnf
