#!/bin/bash

LOG=/home/millegrilles/logs/trigger_quotidien

echo -e "\n" >> $LOG.log
echo `date` >> $LOG.log
echo -e "\n" >> $LOG.err
echo `date` >> $LOG.err

docker run --rm --env-file /home/millegrilles/env.txt \
registry.maple.mdugre.info:5000/millegrilles_domaines_python.x86_64:v0.5.1 \
demarrer_declencheur.py -m senseurspassifs_maj_quotidienne \
>> $LOG.log 2>> $LOG.err

