#!/bin/bash

# Executer find . -type f -exec ./dostuff.sh {} \;

BASENAME=`basename $1`
#DEST="/var/lib/docker/volumes/millegrilles-consignation/_data/local"

#mkdir -p "$DEST"

echo "Link $BASENAME"
# ln $1 "$BASENAME"
