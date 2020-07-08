#!/usr/bin/env bash

if [ -d blynk-server ]; then
  git -C blynk-server pull
else
  git clone https://github.com/blynkkk/blynk-server.git
  ln -s blynk-server/server/Docker docker-blynk
fi

cp image_info.txt docker-blynk

cd docker-blynk
docker-build.sh

exit 1
