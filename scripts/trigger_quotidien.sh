#!/bin/bash

docker run --rm -it --env-file /home/millegrilles/env.txt \
registry.maple.mdugre.info:5000/millegrilles_domaines_python.x86_64:v0.5.1 \
demarrer_declencheur.py -m senseurspassifs_maj_quotidienne
