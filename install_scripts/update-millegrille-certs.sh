#!/usr/bin/env bash

# Ce script sert a mettre a jour le certificat de millegrille.
# Le comportement est different selon la presence ou l'absence du mot de
# passe intermediaire:
#   - si le mot de passe est present, le processus est automatique
#   - si le mot de passe est absent, le script va produire une requete (CSR)
#     et ouvrir un editeur nano pour recevoir le nouveau certificat signe.

set -e  # Quitter pour toute erreur

if [ -z $1 ]; then
  echo "Il faut fournir les parametres suivants:"
  echo "  1-NOM_MILLEGRILLE"
  exit 1
fi

# Charger le DOMAIN_SUFFIX, utilise pour les certificats
export NOM_MILLEGRILLE=$1
source /opt/millegrilles/etc/$NOM_MILLEGRILLE.conf
export DOMAIN_SUFFIX
source /opt/millegrilles/etc/variables.txt
# source /opt/millegrilles/bin/setup-certs-fonctions.sh

export CURDATE=$CURDATE_NOW \
       CNF_FILE=$ETC_FOLDER/openssl-millegrille.cnf

generer_pass_random() {
 FICHIER_CURDATE=$1.$CURDATE
 if [ ! -f $FICHIER_CURDATE ]; then
   openssl rand -base64 32 > $FICHIER_CURDATE
   chmod 400 $FICHIER_CURDATE
 fi
 export PASSWD_FILE_THIS=$FICHIER_CURDATE
}

demander_signature_externe() {
  echo "[INFO] demander_signature_externe() Voici la requete de certificat. Copier le contenu pour signer avec l'autorite appropriee."
  echo ""
  cat $REQ
  echo ""
  read -p "Appuyez sur [ENTREE] pour continuer"

  echo "# Veuillez coller le certificat a la suite de ce fichier et appuyer sur CTRL-X" | tee $CERT
  nano $CERT
}

signer_automatiquement() {
  echo "[INFO] Certificat intermediaire, cle et mot de passe presents. Le certificat va etre signe autoamtiquement."

  CNF_FILE=$ETC_FOLDER/openssl-intermediaire.cnf
  echo -e "[INFO] signer_automatiquement(): Signer \nrequete $REQ\nCNF $CNF_FILE\noutput $CERT"

  openssl ca -config $CNF_FILE \
          -policy signing_policy \
          -extensions signing_req \
          -keyfile $CAINTER_KEY_PATH -keyform PEM \
          -out $CERT \
          -passin file:$INTER_PASSWD_FILE \
          -batch \
          -notext \
          -infiles $REQ

  if [ $? -ne 0 ]; then
    echo -e "\n[FAIL] signer_automatiquement() Erreur signature $REQ"
    exit 38
  fi

  # La requete CSR n'est plus necessaire
  rm $REQ
}

renouveler_cert_millegrille() {

  NOMCLE=${NOM_MILLEGRILLE}_millegrille
  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  KEY_LINK=$PRIVATE_PATH/${NOMCLE}.key.pem
  export REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem
  export CERT=`echo $REQ | sed s/\.csr/\.cert/g`

  SUBJECT="/C=CA/ST=Ontario/L=Russell/O=MilleGrilles/OU=MilleGrille/CN=$NOM_MILLEGRILLE"

  if [ -f $KEY ]; then
    echo "Cle $KEY existe deja - on abandonne"
    exit 34
  fi

  # Generer un mot de passe (s'il n'existe pas deja - pas overwrite)
  generer_pass_random $MILLEGRILLE_PASSWD_FILE

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

  # Verifier si on peut proceder a la signature immediatement (cle et password
  # intermediaire present localement) ou s'il faut demander une signature tierce.
  if [ -f $INTER_PASSWD_FILE ] && [ -f $CAINTER_CERT ]; then
    signer_automatiquement
  else
    demander_signature_externe
  fi

  # Verifier si le certificat est lisible et valide
  SUBJECT=`openssl x509 -noout -subject -in $CERT`
  if [ $? != 0 ]; then
    echo "[FAIL] Le certificat n'est pas lisible."
    exit 2
  fi
  echo "[INFO] Le certificat semble correct: $SUBJECT"

  update_links
}

update_links() {
  # Creer lien generique pour la cle root
  chmod 644 $CERT
  chmod 400 $KEY

  CA_DBPATH=$DBS_PATH/${NOMCLE}

  if [ ! -d $CA_DBPATH ]; then
    mkdir -p $CA_DBPATH/certs
    touch $CA_DBPATH/index.txt
    touch $CA_DBPATH/index.txt.attr
    echo "01" > $CA_DBPATH/serial.txt
  fi

  echo "[INFO] Tous les fichiers ont ete crees, on modifie des liens de certificats."
  ln -sf $KEY $KEY_LINK
  ln -sf $CERT $CERT_PATH/${NOMCLE}.cert.pem
  ln -sf $PASSWD_FILE_THIS $PASSWORDS_PATH/cert_millegrille_password.txt
  rm $CERT_PATH/*.csr.pem
  echo -e "\n[OK] Le nouveau certificat est installe sous $CERT_PATH/${NOMCLE}.cert.pem\n"
}

sequence() {
  echo -e "[INFO] Generer une nouvelle cle et certificat pour la millegrille"
  renouveler_cert_millegrille
}

sequence
