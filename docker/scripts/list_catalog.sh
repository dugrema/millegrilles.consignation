#!/bin/bash

export Register=https://registry.maple.mdugre.info:5000
export cLink="/v2/_catalog?n=10"
export cFile=docker.register.catalog
export tFile=docker.register.tags

function listFullCatalog {

 while true; do
  wget -O- -q -S "${Register}${cLink}" \
   2>${cFile} \
   | json_pp -t json | grep -F  "      " | cut -d\" -f2 | listTags

  cLink=`grep Link ${cFile} 2>/dev/null | cut -d\< -f2 | cut -d\> -f1`
  if [ ! -n "${cLink}" ] ; then break; fi
 done
}

function listTags {

 cat - | while read image; do
  tLink="/v2/${image}/tags/list?n=10"
  while true; do
   wget -O- -q -S "${Register}${tLink}" \
    2>${tFile} \
    | json_pp -t json | grep -F  "      " | cut -d\" -f2 | sed "s@^@${image}:@"

   tLink=`grep Link ${tFile} 2>/dev/null | cut -d\< -f2 | cut -d\> -f1`
   if [ ! -n "${tLink}" ] ; then break; fi
  done
 done
}

listFullCatalog
