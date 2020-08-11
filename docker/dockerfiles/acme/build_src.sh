#!/bin/bash

if [ -d acme.sh ]; then
  git -C acme.sh pull
else
  git clone --single-branch https://github.com/acmesh-official/acme.sh.git
fi
