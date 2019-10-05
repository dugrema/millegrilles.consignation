#!/usr/bin/env bash

BASE=$PWD
TMP=$PWD/tmp

mkdir -p $TMP

cd $TMP
if [ ! -d $TMP/MilleGrilles.consignation.python ]; then
  git clone ssh://repository.maple.mdugre.info/var/lib/git/MilleGrilles.consignation.python
else
  cd $TMP/MilleGrilles.consignation.python
  git pull
fi
if [ ! -d $TMP/MilleGrilles.deployeur ]; then
  git clone ssh://repository.maple.mdugre.info/var/lib/git/MilleGrilles.deployeur
else
  cd $TMP/MilleGrilles.deployeur
  git pull
fi
cd $BASE
