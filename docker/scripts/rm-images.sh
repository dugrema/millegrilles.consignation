#!/bin/bash

docker image ls -q | \
while read VOL
do
  docker image rm $VOL
done

#egrep '([a-z0-9]{12})' | \
