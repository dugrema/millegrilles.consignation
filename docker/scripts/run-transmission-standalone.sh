#!/usr/bin/env bash

MG_TORRENTS_FOLDER=/opt/millegrilles/dev3/mounts/consignation/torrents
TORRENTS_FOLDER=$MG_TORRENTS_FOLDER
WATCH_FOLDER=$MG_TORRENTS_FOLDER/watch
STAGING_FOLDER=$MG_TORRENTS_FOLDER/downloads

docker container run -d --rm \
  --network host \
  --name=transmission \
  -e PGID=980 \
  -e TZ=America/Toronto \
  -e USER=millegrilles \
  -e PASS=bwahahah1202 \
  -v $STAGING_FOLDER:/downloads \
  -v $WATCH_FOLDER:/watch \
  -v $TORRENTS_FOLDER:/torrents \
  -l ipv6.mapper.network=mg_ipv6 \
  docker.maceroc.com/transmission:2.94-r2-ls35

#  --restart unless-stopped \
#   -v path to data:/config \
# -p 9091:9091 \
# -p 51413:51413 \
# -p 51413:51413/udp \
