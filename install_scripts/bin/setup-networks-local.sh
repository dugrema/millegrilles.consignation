#!/bin/bash
echo "Creer reseau overlay millegrilles"
docker network create -d overlay mg_net

# Le subnet/gateway IPv4 est fourni pour eviter un conflit avec le
# defaut de docker (172.19.0.0/16)
docker network create \
       --driver=bridge \
       --attachable \
       --subnet=172.30.0.0/16 \
       --gateway=172.30.0.1 \
       --ipv6 \
       --subnet=fe80:0:0:0:2800::/88 \
       ipv6_bridge_link
