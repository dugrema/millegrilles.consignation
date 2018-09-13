#!/bin/bash

REPO=repository.maple.mdugre.info:5000
NAME=mg_transactions
VERSION=1.0
ARCH=`uname -m`

docker run $REPO/$NAME.$ARCH:$VERSION

