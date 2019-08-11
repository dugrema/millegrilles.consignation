#!/usr/bin/env bash

# Parametres obligatoires
if [ -z $NOM_MILLEGRILLE ] || [ -z $DOMAIN_SUFFIX ] || [ -z $REQ ]; then
  echo "Les parametres NOM_MILLEGRILLE, DOMAIN_SUFFIX et REQ doivent etre definis globalement"
  exit 1
fi

# Parametres optionnel
if [ -z $CURDATE ]; then
  CURDATE=`date +%Y%m%d%H%M`
fi

# Importer les variables et fonctions
source /opt/millegrilles/etc/variables.txt
source setup-certs-fonctions.sh

# Sequence
sequence_chargement() {
  # Creer le certificat noeud
  echo -e "\n*****\nSigner un certificat de noeud"

  # Changer l'extension .csr.pem pour .cert pour generer la requete
  CERT=`echo $REQ | sed s/\.csr/\.cert/g`

  SUFFIX_NOMCLE=middleware \
  CNF_FILE=$ETC_FOLDER/openssl-millegrille.cnf \
  KEYFILE=$MG_KEY \
  PASSWD_FILE=$MILLEGRILLE_PASSWD_FILE \
  REQ=$REQ \
  CERT=$CERT \
  signer_cert

  if [ $? != 0 ]; then
    exit $?
  fi

  echo -e "\nCertificat cree, copier vers noeud\n"
  cat $CERT

}

# Executer
sequence_chargement
