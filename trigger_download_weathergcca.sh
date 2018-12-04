#!/bin/bash

LOG=/home/millegrilles/logs/trigger_download_weathergcca

echo -e "\n" >> $LOG.log
echo `date` >> $LOG.log
echo -e "\n" >> $LOG.err
echo `date` >> $LOG.err

docker run --rm --env-file /home/millegrilles/env.txt \
registry.maple.mdugre.info:5000/millegrilles_domaines_python.x86_64:v0.6.3 \
demarrer_RSSDownload.py \
--domaine mgdomaines.appareils.WebPoll.RSS.weather_gc_ca.on_52_e \
https://weather.gc.ca/rss/city/on-52_e.xml \
>> $LOG.log 2>> $LOG.err
