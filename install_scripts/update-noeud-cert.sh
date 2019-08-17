#!/usr/bin/env bash

# Ce script sert a creer ou mettre a jour le certificat d'un noeud.
set -e  # Quitter pour toute erreur

if [ -z $1 ]; then
  echo "Il faut fournir les parametres suivants:"
  echo "  1-NOM_MILLEGRILLE"
  exit 1
fi

export NOM_MILLEGRILLE=$1
source /opt/millegrilles/etc/variables.txt

creer_cert_noeud() {
  # Utilise pour creer un certificat de noeud (middleware, etc.)
  # Parametres :
  #    SUFFIX_NOMCLE
  #    CNF_FILE

  NOMCLE=${NOM_MILLEGRILLE}_$HOSTNAME
  if [ -z $TYPE_NOEUD ]; then
    TYPE_NOEUD=Noeud
  fi

  CNF_FILE=$MG_FOLDER_ETC/openssl-millegrille-noeud.cnf
  CURDATE=$CURDATE_NOW

  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  export REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem
  CERT=$CERT_PATH/${NOMCLE}_${CURDATE}.cert.pem

  SUBJECT="/C=CA/ST=Ontario/L=Russell/O=$NOM_MILLEGRILLE/OU=$TYPE_NOEUD/CN=$HOSTNAME_SHORT/emailAddress=$NOM_MILLEGRILLE@millegrilles.com"

  if [ -f $KEY ]; then
    echo "Cle $KEY existe deja - on abandonne"
  fi

  echo "Hostname short: $HOSTNAME_SHORT"

  HOSTNAME=$HOSTNAME_SHORT NOM_NOEUD=$HOSTNAME_SHORT \
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

}

attendre_certificat() {
  # REQ=/va/dfsfd/fjdsij/fjjj.cert.pem
  SERVEUR=mg-${NOM_MILLEGRILLE}.local
  URL=https://${SERVEUR}${CERT_PATH}/$HOSTNAME_SHORT.local.cert.pem
  CERT_PATH=/pki/certs
  
  echo -e "Requete a transmettre au serveur MilleGrille:\n$REQ\n\n"
  
  cat $REQ
  
  echo ""
  echo "Le noeud va tenter de lire le certificat a partir de: $URL"
  echo 'Appuyez sur ENTREE lorsque le certificat sera pret'
  
  read -p "Telecharger le fichier? (Y/n) " $REP
  if [ $REP == '' ] || [$REP == 'y']; then
    wget --ca-certificate=$MG_FOLDER_CERTS/${NOM_MILLEGRILLE}_CA_chain.cert.pem \
         $URL
  fi
}

# Demarrer l'execution
creer_cert_noeud
attendre_certificat
