#!/usr/bin/env bash

if [ -z $APP_BUNDLE_FOLDER ]; then
  ERREUR="$ERREUR APP_BUNDLE_FOLDER"
fi
if [ -z $MG_NOM_MILLEGRILLE ]; then
  ERREUR="$ERREUR MG_NOM_MILLEGRILLE"
fi
if [ -z $MQ_MIDDLEWARE_SUBJECT ]; then
  ERREUR="$ERREUR MQ_MIDDLEWARE_SUBJECT"
fi
if [ ! -z "$ERREUR" ]; then
  echo "Parametres manquants: $ERREUR"
  exit 1
fi

cat $APP_BUNDLE_FOLDER/definitions_template.json | \
sed "s/\"sansnom\"/\"$MG_NOM_MILLEGRILLE\"/" - |
sed "s/\"middleware\"/\"$MQ_MIDDLEWARE_SUBJECT\"/" -
