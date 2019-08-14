#!/usr/bin/env bash

if [ -z $1 ]; then
  echo "Fournir le nom de domaine en parametre"
  exit 1
fi

generer() {
  ipv6addr=$(echo $1|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/fe80::28\1:\2\3\:4\5:\6\7/');
}

activer() {
  echo "Activation de l'interface locale $ipv6addr"
  ip -6 address add $2 scope link dev eth0
  echo "Ajout dans avahi hosts"
  echo "$2 $1" >> /etc/avahi/hosts
}

generer $1
activer $1 $ipv6addr
