#!/bin/env bash

# Repair
docker run -it --rm -v mongo-data:/data/db mongo:8 mongod --repair --storageEngine wiredTiger
