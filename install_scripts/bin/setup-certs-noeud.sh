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

# Importer les variables et fonctions
source /opt/millegrilles/etc/variables.txt
source setup-certs-fonctions.sh

# Creer les repertoires pour recevoir la cle, requetes et certificats
mkdir -p $PRIVATE_PATH $CERT_PATH
if [ $? != 0 ]; then
  echo -e "\n[FAIL] Echec de creation de repertoires pour recevoir les certificats\n"
  exit 1
fi
chmod 700 $PRIVATE_PATH

# Sequence
sequence_chargement() {
  # Creer le certificat noeud
  echo -e "\n*****\nGenerer une requete pour certificat de noeud"

  export NOM_NOEUD=$HOSTNAME_SHORT

  NOMCLE=${HOSTNAME}_${SUFFIX_NOMCLE}

  SUFFIX_NOMCLE=$HOSTNAME \
  CNF_FILE=$ETC_FOLDER/openssl-millegrille-noeud.cnf \
  creer_cert_noeud

  if [ $? != 0 ]; then
    exit $?
  fi

  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  chmod 400 $KEY
  ln -sf $KEY $PRIVATE_PATH/$NOMCLE.key.pem

  REQ=${CERT_PATH}/${NOMCLE}_${CURDATE}.csr.pem
  echo "Fournir la requete de certificat pour signer sur le serveur millegrille"
  echo "Requete: $REQ"
  openssl req -in $REQ -text

}

# Executer
sequence_chargement
