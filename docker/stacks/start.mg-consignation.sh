#!/bin/bash

NOM_MILLEGRILLE=dev2

docker stack deploy -c mg-consignation.yml "mg_$NOM_MILLEGRILLE_consignation"
