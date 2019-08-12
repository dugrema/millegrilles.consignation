#!/usr/bin/env bash

set -e  # Arreter l'execution pour un exit

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

# Sequence
sequence_chargement() {

  # Generer les repertoires PKI pour la MilleGrille
  creer_repertoires

  # On ne regenere pas la cle CA si elle existe deja.
  if [ ! -f $CA_KEY ]; then
    echo -e "\n*****\nGenerer un certificat racine self-signed\n"

    SUFFIXE_NOMCLE=ssroot \
    CNF_FILE=$ETC_FOLDER/openssl-rootca.cnf \
    creer_ssrootcert

    if [ $? != 0 ]; then
      exit $?
    fi
  else
    echo -e "\n*****\nCle CA existe ($CA_KEY), on passe cette etape."
  fi

  # On ne regenere pas la cle CA intermediaire si elle existe deja.
  if [ ! -f $CAINTER_KEY_PATH ]; then
    echo -e "\n*****\nGenerer un certificat CA intermediaire\n"

    SUFFIX_NOMCLE=intermediaire \
    CNF_FILE=$ETC_FOLDER/openssl-intermediaire.cnf \
    CN='Intermediaire' \
    EMAIL='intermediaire@millegrilles.com' \
    PASSWD_FILE_THIS=$INTER_PASSWD_FILE \
    CNF_AUTH=$ETC_FOLDER/openssl-rootca.cnf \
    KEY_AUTH=$CA_KEY \
    PASSWD_FILE_AUTH=$SSROOT_PASSWD_FILE \
    creer_certca

    if [ $? != 0 ]; then
      exit $?
    fi
  else
    echo -e "\n*****\nCle intermediaire existe ($CAINTER_KEY_PATH), on passe cette etape."
  fi

  # On ne regenere pas la cle MilleGrille (CA) si elle existe deja,
  # sauf si le flag RENOUV_MILLEGRILLE est present
  if [ ! -f $CERT_PATH/${NOM_MILLEGRILLE}_millegrille.cert.pem ] || [ ! -z $RENOUV_MILLEGRILLE ]; then
    echo -e "\n*****\nGenerer un certificat MilleGrille (CA)\n"

    SUFFIX_NOMCLE=millegrille \
    CNF_FILE=$ETC_FOLDER/openssl-millegrille.cnf \
    CN=$HOSTNAME_SHORT.local \
    EMAIL="$NOM_MILLEGRILLE@millegrilles.com" \
    PASSWD_FILE_THIS=$MILLEGRILLE_PASSWD_FILE \
    CNF_AUTH=$ETC_FOLDER/openssl-intermediaire.cnf \
    KEY_AUTH=$CAINTER_KEY_PATH \
    PASSWD_FILE_AUTH=$INTER_PASSWD_FILE \
    creer_certca

    if [ $? != 0 ]; then
      ERREUR=$?
      echo "[FAIL] Erreur creation certificat de millegrille. Code $ERREUR"
      exit $ERREUR
    fi

    concatener_chaine_certificats_ca

  fi
}

# Executer
sequence_chargement
