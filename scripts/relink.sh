#!/bin/bash

link_sub () {
  SUB1="${1: -2}"
  NAME=`basename "${1}"`
  #echo "mkdir -p $SUB1"
  mkdir -p "$SUB1"
  #echo "ln $1 $SUB1/$NAME"
  ln "$1" "$SUB1/$NAME"
}

export -f link_sub

#link_sub "monfichier"

find $1 -type f -exec bash -c 'link_sub "{}"' \;
