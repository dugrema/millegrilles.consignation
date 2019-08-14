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
source /opt/millegrilles/etc/$NOM_MILLEGRILLE.conf
export NOM_MILLEGRILLE DOMAIN_SUFFIX
source /opt/millegrilles/etc/variables.txt
source /opt/millegrilles/bin/setup-certs-fonctions.sh
CURDATE=$CURDATE_NOW

renouveler_cert_middleware() {

  export SUFFIX_NOMCLE=middleware TYPE_NOEUD=Middleware
  NOMCLE=${NOM_MILLEGRILLE}_${SUFFIX_NOMCLE}

  CNF_FILE=$ETC_FOLDER/openssl-millegrille-middleware.cnf \
  creer_cert_noeud
  chmod 400 $KEY

  if [ $? != 0 ]; then
    exit $?
  fi

  NOMCLE=${NOM_MILLEGRILLE}_${SUFFIX_NOMCLE}
  REQ=$CERT_PATH/${NOMCLE}_${CURDATE}.csr.pem
  KEY=$PRIVATE_PATH/${NOMCLE}_${CURDATE}.key.pem
  CERT=$CERT_PATH/${NOMCLE}_${CURDATE}.cert.pem

  echo "Voici la requete de certifcat. Copier le contenu pour signer avec l'autorite appropriee."
  echo ""
  cat $REQ
  echo ""
  read -p "Appuyez sur [ENTREE] pour continuer"

  echo "# Veuillez coller le certificat a la suite de ce fichier et appuyer sur CTRL-X" | tee $CERT
  nano $CERT

  # Verifier si le certificat est lisible et valide
  openssl x509 -noout -subject -in $CERT
  echo "[INFO] Le certificat semble correct, on l'installe"

  chmod 444 $CERT

  echo "[INFO] Tous les fichiers ont ete crees, on modifie des liens de certificats."

  ln -sf $KEY $PRIVATE_PATH/${NOMCLE}.key.pem
  ln -sf $CERT $CERT_PATH/${NOMCLE}.cert.pem

  echo -e "\n[OK] Le nouveau certificat est installe sous $CERT_PATH/${NOMCLE}.cert.pem\n"

}

sequence() {
  echo -e "[INFO] Generer une nouvelle cle et certificat pour le noeud middleware"
  renouveler_cert_middleware

  echo -e "[INFO] Importer le nouveau certificat et cle dans docker (ssl)"
  importer_dans_docker

  echo -e "[INFO] Importer le nouveau certificat et cle dans docker (web)"
  importer_public_ss
}

sequence
