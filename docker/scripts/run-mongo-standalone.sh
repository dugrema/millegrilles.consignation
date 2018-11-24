#!/bin/bash

docker container run -it \
  -e "MONGO_INITDB_ROOT_USERNAME=root" \
  -e "MONGO_INITDB_ROOT_PASSWORD=example" \
  -v mg-consignation-mongo:/data/db \
  registry.maple.mdugre.info:5000/mg_mongo:1.2 \
  bash

