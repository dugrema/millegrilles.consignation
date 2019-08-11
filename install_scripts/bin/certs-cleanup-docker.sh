#!/usr/bin/env bash

echo -e "Nettoyage docker secrets"

identifier_secrets() {
  if [ -z $PREFIXE ]; then
    echo -e "\n[FAIL] identifier_secrets(): Il faut fournir le PREFIXE du secret\n"
    exit 1
  fi

  if [ -z $DATE_CONSERVER ]; then
    DATE_CONSERVER="-NONE-"
  fi

  SECRETS=`docker secret ls | awk '{print $2}' | grep $PREFIXE`

  for SECRET in ${SECRETS[@]}; do
    DATE_SECRET=`echo $SECRET | awk 'BEGIN{FS="."} {print $NF}'`
    if [ $DATE_SECRET != $DATE_CONSERVER ]; then
      echo "Suppression secret $SECRET"
      docker secret rm $SECRET
    fi
  done
}

identifier_secrets
