#!/usr/bin/env bash
# Ce script sert a creer et faire l'entretien d'un certificat Root CA self-signed
# et des certificats de signature intermediaires.

source /opt/millegrilles/etc/variables.txt

creer_ssrootcert() {
  # Utilise pour creer un certificat self-signed racine pour une millegrille.
  # Parametres:
  #  SUFFIXE_NOMCLE
  #  CNF_FILE

  NOMCLE=${NOM_MILLEGRILLE}_${SUFFIXE_NOMCLE}

  SUBJECT="/C=CA/ST=Ontario/L=Russell/O=MilleGrilles/OU=SSRoot/CN=ssroot.millegrilles.com/emailAddress=ssroot@millegrilles.com"

  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  SSCERT=$CERT_PATH/${NOMCLE}_${CURDATE}.cert.pem
  let "DAYS=365 * 10"  # 10 ans

  if [ -f $KEY ]; then
    echo "creer_ssrootcert() Cle $KEY existe deja - on abandonne"
    exit 31
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
    echo "creer_ssrootcert() Erreur openssl creer_ssrootcert()"
    exit 32
  fi

  # Creer lien generique pour la cle root
  chmod 400 $KEY
  chmod 444 $SSCERT
  ln -sf $KEY $CA_KEY
  ln -sf $SSCERT $CA_CERT

  SSROOT_DBPATH=$DBS_PATH/${NOM_MILLEGRILLE}_root

  if [ ! -d $SSROOT_DBPATH ]; then
    # Preparer le repertoire de DB pour signature
    mkdir -p $SSROOT_DBPATH/certs
    touch $SSROOT_DBPATH/index.txt
    touch $SSROOT_DBPATH/index.txt.attr
    echo "01" > $SSROOT_DBPATH/serial.txt
  fi

}

creer_certca() {
  # Utilse pour creer un certificat CA (intermediaire ou millegrille)
  # Parametres :
  #  SUFFIX_NOMCLE
  #  CNF_FILE
  #  CN
  #  EMAIL
  #  PASSWD_FILE_THIS
  #  CNF_AUTH
  #  KEY_AUTH
  #  PASSWD_FILE_AUTH

  if [ -z $SUFFIX_NOMCLE ] || [ -z $CNF_FILE ] || [ -z $CN ] || [ -z $EMAIL ] || [ -z $PASSWD_FILE_THIS ] || \
     [ -z $CNF_AUTH ] || [ -z $KEY_AUTH ] || [ -z $PASSWD_FILE_AUTH ]; then
    echo "creer_certca() Parametres: NOMCLE, CNF_FILE, CN, EMAIL, PASSWD_FILE_THIS, CNF_AUTH, KEY_AUTH, PASSWD_FILE_AUTH"
    exit 33
  fi

  NOMCLE=${NOM_MILLEGRILLE}_${SUFFIX_NOMCLE}
  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  KEY_LINK=$PRIVATE_PATH/${NOMCLE}.key.pem
  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem

  SUBJECT="/C=CA/ST=Ontario/L=Russell/O=MilleGrilles/OU=MilleGrille/CN=$CN/emailAddress=$EMAIL"

  if [ -f $KEY ]; then
    echo "Cle $KEY existe deja - on abandonne"
    exit 34
  fi

  # Generer un mot de passe (s'il n'existe pas deja - pas overwrite)
  generer_pass_random $PASSWD_FILE_THIS

  HOSTNAME=$HOSTNAME_SHORT DOMAIN_SUFFIX=$DOMAIN_SUFFIX \
  openssl req \
          -config $CNF_FILE \
          -newkey rsa:4096 -sha512 \
          -out $REQ -outform PEM \
          -keyout $KEY -keyform PEM \
          -subj $SUBJECT \
          -passout file:$PASSWD_FILE_THIS

  if [ $? -ne 0 ]; then
    echo "Erreur openssl creer_certca_millegrille()"
    exit 35
  fi

  SUFFIXE_NOMCLE=$SUFFIX_NOMCLE \
  CNF_FILE=$CNF_AUTH \
  KEYFILE=$KEY_AUTH \
  PASSWD_FILE=$PASSWD_FILE_AUTH \
  signer_cert

  # Creer lien generique pour la cle root
  chmod 400 $KEY
  ln -sf $KEY $KEY_LINK
  ln -sf $CERT $CERT_PATH/${NOMCLE}.cert.pem

  CA_DBPATH=$DBS_PATH/${NOMCLE}

  if [ ! -d $CA_DBPATH ]; then
    mkdir -p $CA_DBPATH/certs
    touch $CA_DBPATH/index.txt
    touch $CA_DBPATH/index.txt.attr
    echo "01" > $CA_DBPATH/serial.txt
  fi

}

creer_cert_noeud() {
  # Utilise pour creer un certificat de noeud (middleware, etc.)

  NOMCLE=$1
  CNF_FILE=$2

  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem

  SUBJECT="/C=CA/ST=Ontario/L=Russell/O=MilleGrilles/OU=Noeud/CN=$HOSTNAME/emailAddress=$NOM_MILLEGRILLE@millegrilles.com"

  if [ -f $KEY ]; then
    echo "Cle $KEY existe deja - on abandonne"
  fi

  HOSTNAME=$HOSTNAME_SHORT DOMAIN_SUFFIX=$DOMAIN_SUFFIX \
  openssl req \
          -config $CNF_FILE \
          -newkey rsa:2048 -sha512 \
          -out $REQ -outform PEM \
          -keyout $KEY -keyform PEM \
          -subj $SUBJECT \
          -nodes

  if [ $? -ne 0 ]; then
    echo "Erreur openssl creer_cert_noeud()"
    exit 36
  fi

  HOSTNAME=$HOSTNAME_SHORT \
  DOMAIN_SUFFIX=$DOMAIN_SUFFIX \
  SUFFIXE_NOMCLE=$SUFFIXE_NOMCLE \
  CNF_FILE=$ETC_FOLDER/openssl-millegrille.cnf \
  KEYFILE=$MG_KEY \
  PASSWD_FILE=$MILLEGRILLE_PASSWD_FILE
  signer_cert

}

signer_cert() {
  # Signe un certificat avec un CA
  # Parametres :
  #   SUFFIXE_NOMCLE
  #   CNF_FILE
  #   KEYFILE
  #   PASSWD_FILE

  NOMCLE=${NOM_MILLEGRILLE}_${SUFFIX_NOMCLE}

  if [ -z $SUFFIXE_NOMCLE ] || [ -z $CNF_FILE ] || [ -z $KEYFILE ] || [ -z $PASSWD_FILE ]; then
    echo "signer_cert(): Parametres NOMCLE CNF_FILE KEYFILE PASSWD_FILE"
    exit 37
  fi

  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem
  CERT=$CERT_PATH/${NOMCLE}_${CURDATE}.cert.pem

  echo -e "signer_cert(): Signer requete $REQ\n CNF $CNF_FILE\n KEY $KEYFILE"

  openssl ca -config $CNF_FILE \
          -policy signing_policy \
          -extensions signing_req \
          -keyfile $KEYFILE -keyform PEM \
          -out $CERT \
          -passin file:$PASSWD_FILE \
          -batch \
          -notext \
          -infiles $REQ

  if [ $? -ne 0 ]; then
    echo -e "\n[FAIL] signer_cert() Erreur signature $SUFFIXE_NOMCLE"
    exit 38
  fi

  # La requete CSR n'est plus necessaire
  rm $REQ
}

concatener_chaine_certificats_ca() {
  # Concatene la chaine de certificats dans un seul fichier.
  # Parametres :
  #  FULLCHAIN_FILE: Chemin et nom du fichier a generer
  #  NOM_MILLEGRILLE: Nom de la millegrille

  if [ -z $CA_CHAIN_FILE ]; then
    echo "[FAIL] concatener_chaine_certificats() Il faut fournir le parametre CA_CHAIN_FILE"
    exit 39
  fi

  cat \
    $CERT_PATH/*_ssroot_*.cert.pem \
    $CERT_PATH/*_intermediaire_*.cert.pem \
    $CERT_PATH/*_millegrille_*.cert.pem \
    > $CA_CHAIN_FILE
}

generer_pass_random() {
  FICHIER_CURDATE=$1.$CURDATE
  if [ ! -f $FICHIER_CURDATE ]; then
    openssl rand -base64 32 > $FICHIER_CURDATE
    chmod 400 $FICHIER_CURDATE
    ln -sf $FICHIER_CURDATE $1
  fi
}
