#!/usr/bin/env bash

cd /opt/rabbitmq/dist

mkdir -p /run/secrets

cp pki.millegrilles.* /run/secrets/
chown root:rabbitmq /run/secrets/*
chmod 440 /run/secrets/*

# cp -f rabbitmq.config /etc/rabbitmq
