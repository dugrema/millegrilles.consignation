#!/bin/bash

source /usr/local/etc/mg-timers.env

python3 $SRC/mgdomaines/appareils/DeclencheursAppareils.py -m senseurspassifs_maj_horaire

