#!/bin/sh

# Creer ACL
creer_acl.sh

# Demarrer serveur
# redis-server
redis-server /usr/local/etc/redis.conf
