#!/bin/bash
source image_info.txt
docker pull linuxserver/transmission:$BRANCH
docker tag linuxserver/transmission:$BRANCH docker.maceroc.com/transmission:$BRANCH
docker push docker.maceroc.com/transmission:$BRANCH
