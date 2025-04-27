#!/bin/env bash

tar -zcf /home/mathieu/backup/jenkins.tar.gz \
  --exclude="/var/lib/jenkins/jobs/*/builds" \
  /var/lib/jenkins/*.xml \
  /var/lib/jenkins/jobs

