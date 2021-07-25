#!/usr/bin/env bash

docker run -d --rm \
  --name elasticsearch \
  --net millegrille_net \
  -p 9200:9200 \
  -p 9300:9300 \
  -e "discovery.type=single-node" \
  -e "ES_JAVA_OPTS=-Xms384m -Xmx512m" \
  -v elasticsearch:/usr/share/elasticsearch/data \
  elasticsearch:7.13.4
