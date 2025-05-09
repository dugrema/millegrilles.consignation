#!/bin/bash

MAX_ARCHIVES=4
NOM_FICHIER=$1

if [ -z "$NOM_FICHIER" ]; then
    echo "Il faut fournir un fichier"
    exit 1
fi

if [ ! -f "${NOM_FICHIER}" ]; then
    echo "Fichier ${NOM_FICHIER} absent"
    exit 2
fi

VAR=$MAX_ARCHIVES
while [ $VAR -gt 0 ]; do
    let VARNEXT=$VAR
    let VARPREV=$VAR-2
    let VAR=$VAR-1

    if [ $VAR -eq 0 ]; then
        FICHIER_SOURCE="${NOM_FICHIER}"
        FICHIER_PRECEDENT="${FICHIER_SOURCE}"
    elif [ $VAR -eq 1 ]; then
        FICHIER_SOURCE="${NOM_FICHIER}.1"
        FICHIER_PRECEDENT="${NOM_FICHIER}"
    else
        FICHIER_SOURCE="${NOM_FICHIER}.${VAR}"
        FICHIER_PRECEDENT="${NOM_FICHIER}.${VARPREV}"
    fi

    if [ -f "${FICHIER_PRECEDENT}" ]; then
        mv "${FICHIER_SOURCE}" "${NOM_FICHIER}.${VARNEXT}"
    fi
done

rm "${NOM_FICHIER}.${MAX_ARCHIVES}"  # Derniere version
