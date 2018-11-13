#!/bin/bash

NOM_MILLEGRILLE=dev2

docker stack deploy -c mg-consignation-middleware.yml mg-consignation-middleware-$NOM_MILLEGRILLE
