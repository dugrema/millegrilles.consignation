#!/usr/bin/env bash

FICHIERS_CERTS_ROOT=/opt/millegrilles/etc

if [ -d $FICHIERS_CERTS_ROOT ]; then
  echo "Copier plus recents certificats root MilleGrilles"
  mkdir -p certs
  cp -f $FICHIERS_CERTS_ROOT/*.pem certs/
fi
