#!/usr/bin/env bash

if [ -d docker-blynk ]; then
  git -C docker-blynk pull
else
  git clone https://github.com/riftbit/docker-blynk.git
fi

cp image_info.txt docker-blynk

cd docker-blynk
docker-build

exit 1
