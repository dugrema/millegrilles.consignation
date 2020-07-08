#!/usr/bin/env bash

if [ -d docker-blynk ]; then
  git -C docker-blynk pull
else
  git clone https://github.com/riftbit/docker-blynk.git
  # ln -s blynk-server/server/Docker docker-blynk
fi

cp image_info.txt docker-blynk

cd docker-blynk
docker-build.sh

exit 1
