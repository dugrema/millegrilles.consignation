#!/bin/bash

source image_info.txt

docker run -d \
  -p 80:80 \
  -p 443:443 \
  $REPO/$NAME.x86_64:$VERSION
