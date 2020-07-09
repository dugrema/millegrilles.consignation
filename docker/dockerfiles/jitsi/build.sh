#!#!/usr/bin/env bash

IMAGES=jicofo

BASE_PWD=$PWD

for IMAGE in $IMAGES; do
  cd $IMAGE
  cp -r ../hooks .
  cp ../image_info.txt .
done
