#!/bin/env bash

VERSION_OLD=`git rev-parse --abbrev-ref HEAD`
VERSION_NEW=$1

if [ -z "${VERSION_NEW}" ]; then
  echo "Fournir parametre: new_branch"
  exit 1
fi

git tag "${VERSION_OLD}-release"
git push --tags
git checkout master
git merge "${VERSION_OLD}"
git push --all
echo "Vieille branche ${VERSION_OLD} taggee pour release et merged avec master"

git checkout -b "${VERSION_NEW}"
git push -u origin "${VERSION_NEW}"

echo "Nouvelle branche ${VERSION_NEW} prete"
