#!/usr/bin/env bash

MG_FOLDER=/opt/millegrilles/dev3
WATCH_FOLDER=$MG_FOLDER/mounts/consignation/torrents
STAGING_FOLDER=$MG_FOLDER/mounts/consignation/torrent_staging

docker container run -d --rm \
  --name=transmission \
  -e PGID=980 \
  -e TZ=America/Toronto \
  -e USER=millegrilles \
  -e PASS=bwahahah1202 \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v $STAGING_FOLDER:/downloads \
  -v $WATCH_FOLDER:/watch \
  --restart unless-stopped \
  docker.maceroc.com/transmission:2.94-r2-ls35

#   -v path to data:/config \
