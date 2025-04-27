#!/bin/bash
echo -n "Running "; date
wget -q -O /dev/null --read-timeout=0.0 --waitretry=5 --tries=400 --background https://
