#!/usr/bin/env bash

# Ce script sert a mettre a jour le certificat de millegrille.
# Le comportement est different selon la presence ou l'absence du mot de
# passe intermediaire:
#   - si le mot de passe est present, le processus est automatique
#   - si le mot de passe est absent, le script va produire une requete (CSR)
#     et ouvrir un editeur nano pour recevoir le nouveau certificat signe.

if [ -z $1 ]; then
  echo "Il faut fournir les parametres suivants:"
  echo "  1-NOM_MILLEGRILLE"
  exit 1
fi
