#!/bin/bash

echo "Creer reseau overlay millegrilles"
docker network create -d overlay --opt encrypted mg_net

