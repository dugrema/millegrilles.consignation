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

  # Generer un mot de passe (s'il n'existe pas deja - pas overwrite)
  generer_pass_random $SSROOT_PASSWD_FILE

  openssl req -x509 -config $CNF_FILE \
          -sha512 -days $DAYS \
          -out $SSCERT -outform PEM \
          -keyout $KEY -keyform PEM \
          -subj $SUBJECT \
          -passout file:$SSROOT_PASSWD_FILE

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

  # Generer un mot de passe (s'il n'existe pas deja - pas overwrite)
  generer_pass_random $MILLEGRILLE_PASSWD_FILE

  HOSTNAME=$HOSTNAME DOMAIN_SUFFIX=$DOMAIN_SUFFIX \
  openssl req \
          -config $CNF_FILE \
          -newkey rsa:4096 -sha512 \
          -out $REQ -outform PEM \
          -keyout $KEY -keyform PEM \
          -subj $SUBJECT \
          -passout file:$MILLEGRILLE_PASSWD_FILE
  if [ $? -ne 0 ]; then
    echo "Erreur openssl creer_certca_millegrille()"
    exit 1
  fi

  signer_cert_par_ssroot $NOMCLE $ETC_FOLDER/openssl-rootca.cnf

  # Creer lien generique pour la cle root
  chmod 400 $KEY
  ln -sf $KEY $MG_KEY
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
          -passin file:$SSROOT_PASSWD_FILE \
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
  signer_cert_par_millegrille $NOMCLE $ETC_FOLDER/openssl-millegrille.cnf

}

signer_cert_par_millegrille() {
  NOMCLE=$1
  CNF_FILE=$2

  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem
  CERT=$CERT_PATH/${NOMCLE}_${CURDATE}.cert.pem

  openssl ca -config $CNF_FILE \
          -policy signing_policy \
          -extensions signing_req \
          -keyfile $MG_KEY -keyform PEM \
          -out $CERT \
          -passin file:$MILLEGRILLE_PASSWD_FILE \
          -batch \
          -infiles $REQ
}

importer_dans_docker() {
  CERT_MIDDLEWARE=$CERT_PATH/${NOM_MILLEGRILLE}_middleware_${CURDATE}.cert.pem
  CLE_MIDDLEWARE=$PRIVATE_PATH/${NOM_MILLEGRILLE}_middleware_${CURDATE}.key.pem

  # Certs root
  cat $CA_CERT $MG_CERT | docker secret create pki.$NOM_MILLEGRILLE.millegrilles.ssl.CAchain.$CURDATE -

  # Cles middleware
  cat $CERT_MIDDLEWARE | docker secret create pki.$NOM_MILLEGRILLE.middleware.ssl.cert.$CURDATE -
  cat $CLE_MIDDLEWARE | docker secret create pki.$NOM_MILLEGRILLE.middleware.ssl.key.$CURDATE -
  cat $CLE_MIDDLEWARE $CERT_MIDDLEWARE | docker secret create pki.$NOM_MILLEGRILLE.middleware.ssl.key_cert.$CURDATE -
}

generer_pass_random() {
  if [ ! -f $1 ]; then
    openssl rand -base64 32 > $1
    chmod 400 $1
  fi
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
