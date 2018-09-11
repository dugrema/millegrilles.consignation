#!/bin/bash

VERSION=v1

docker stack deploy -c mg-consignation.$VERSION.yml mg_sansnom_consignation
