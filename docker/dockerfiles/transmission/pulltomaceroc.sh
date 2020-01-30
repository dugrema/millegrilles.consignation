#!/bin/bash

docker pull linuxserver/transmission:2.94-r2-ls41
docker tag linuxserver/transmission:2.94-r2-ls41 docker.maceroc.com/transmission:2.94-r2-ls41
docker push docker.maceroc.com/transmission:2.94-r2-ls41
