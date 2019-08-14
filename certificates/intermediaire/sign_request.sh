#!/usr/bin/env bash

CNF_FILE=openssl-intermediaire-signature.cnf

if [ -z $NOM_OU ]; then
  echo "Il faut fournir les parametres suivants: nom_noeud"
fi

signer_certificat() {
  openssl ca -config $CNF_FILE \
          -policy signing_policy \
          -extensions signing_req \
          -out ${CERT} \
          -infiles ${REQ}

  if [ $? -ne 0 ]; then
    echo "[FAIL] Erreur de signature du certificat"
    exit 3
  fi
}

# Creer et signer un nouveau certificat
export REQ=~/certificates/csr/cert.csr
export CERT=`echo $REQ | sed s/\.csr/\.cert/ -`
echo "# Copier information requete CSR" > $REQ
nano $REQ

signer_certificat

if [ $? == 0 ]; then
  echo "[OK] Nouveau certificat signe correctement"
  cat $CERT
else
  echo "[FAIL] Erreur signature"
fi
