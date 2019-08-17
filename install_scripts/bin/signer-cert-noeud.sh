#!/usr/bin/env bash

if [ -z $1 ]; then
  echo "Parametre manquant: 1-NOM_MILLEGRILLE"
  exit 1
fi
export NOM_MILLEGRILLE=$1
source /opt/millegrilles/etc/variables.txt
source /opt/millegrilles/etc/$NOM_MILLEGRILLE.conf
export DOMAIN_SUFFIX

# if [ -z $NOM_OU ]; then
#   echo "Il faut fournir les parametres suivants: nom_noeud"
# fi

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
REQ=$(mktemp /tmp/req-pem.XXXXXX)
echo "# Copier la requete de certificat ici" > $REQ
nano $REQ

SUBJECT=$(openssl req -noout -subject -in $REQ)
SUBJECT=(`echo $SUBJECT | sed s/subject=//g | sed s/' '//g | sed s/,/' '/g `)
if [ $? != 0 ]; then
  echo "Erreur, certificat illisible"
  exit 3
fi
declare -A cert_fields
for field in "${SUBJECT[@]}"; do
  field=(`echo $field | sed s/=/' '/g`)
  cert_fields[${field[0]}]=${field[1]}
done

NOM_NOEUD=${cert_fields['CN']}
echo "Certificat pour: $NOM_NOEUD"
echo ${cert_fields[@]}

export CNF_FILE=$MG_FOLDER_ETC/openssl-millegrille.cnf
export CERT=$REQ.cert
export HOSTNAME=`hostname --fqdn`

signer_certificat

if [ $? == 0 ]; then
  echo "[OK] Nouveau certificat signe correctement"
  cat $CERT

  sudo mkdir -p $MG_FOLDER_NGINX_WWW_LOCAL/pki/certs $MG_FOLDER_NGINX_WWW_PUBLIC/pki/certs
  sudo cp -f $CERT $MG_FOLDER_NGINX_WWW_LOCAL/pki/certs/${NOM_NOEUD}.local.cert.pem
  sudo cp -f $CERT $MG_FOLDER_NGINX_WWW_PUBLIC/pki/certs/${NOM_NOEUD}.local.cert.pem
else
  echo "[FAIL] Erreur signature"
fi

rm $REQ $REQ.cert
