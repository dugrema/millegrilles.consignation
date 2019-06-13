#!/usr/bin/env bash

docker run -it \
-p 15671:443 -p 5671-5673:5671-5673 \
-e MG_NOM_MILLEGRILLE=sansnom \
-e MQ_MIDDLEWARE_SUBJECT="CN=dev2.maple.mdugre.info,OU=Middleware,O=dev2,L=Russell,ST=Ontario,C=CA" \
mg_rabbitmq:test run.sh
