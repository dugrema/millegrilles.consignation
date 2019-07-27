#!/usr/bin/env bash
if [ -z $NOM_MILLEGRILLE ]; then
  echo "Le parametre NOM_MILLEGRILLE doit etre definie globalement"
  exit 1
fi

PRIVATE_PATH=/opt/millegrilles/$NOM_MILLEGRILLE/pki/keys
CERT_PATH=/opt/millegrilles/$NOM_MILLEGRILLE/pki/certs

creer_ssrootcert() {
  NOMCLE=$1
  CNF_FILE=$2
  # DAYS=$3
  # CNF_FILE=../etc/openssl-rootca.cnf

  CURDATE=`date +%Y%m%d`
  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  SSCERT=$CERT_PATH/${NOMCLE}_${CURDATE}.cert.pem
  let "DAYS=365 * 10"  # 10 ans

  # if [ -f $KEY ]; then
  #   echo "Cle $KEY existe deja, on abandonne."
  #   exit 1
  # fi

#  -newkey rsa:4096 \

  openssl req -x509 -config $CNF_FILE \
          -sha512 -days $DAYS \
          -out $SSCERT -outform PEM \
          -keyout $KEY -keyform PEM

  # Creer backup de la cle
  chmod 400 $KEY
  ln -s $KEY $PRIVATE_PATH/${NOMCLE}.key.pem
  ln -s $SSCERT $CERT_PATH/${NOMCLE}.cert.pem
}

# signer_cert_request() {
#
# }


# Sequence
creer_ssrootcert \
  ${NOM_MILLEGRILLE}_ssroot \
  ../etc/openssl-rootca.cnf
