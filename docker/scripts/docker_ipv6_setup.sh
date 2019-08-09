#!/bin/bash

INTERFACE=eth0
PREFIX="2607:f2c0:eb70:109b"

sudo sysctl net.ipv6.conf.$INTERFACE.accept_ra=2
sudo sysctl net.ipv6.conf.$INTERFACE.proxy_ndp=1

for ADDRESSE in $(seq 2 16);
do
  ip -6 neigh add proxy "$PREFIX::$ADDRESSE" dev $INTERFACE
done



