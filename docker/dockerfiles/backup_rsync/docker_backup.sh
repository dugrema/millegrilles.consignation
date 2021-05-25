#1/bin/bash

# Param $1 = repertoire source
# Param $2 = destination rsync, e.g. mathieu@mon.serveur.com:/mon/rep/backup/remote

SRC=$1
DEST=$2

echo Demarrer le backup du repertoire $1 vers $2

# Docker volume mg_backup_secret va conserver la cle secrete

docker run --rm \
       -v mg_backup_secret:/secret \
       -v $SRC:/backup \
       --env SRC=/backup \
       --env DEST=$DEST \
       docker.maceroc.com/mg_backup_rsync:x86_64_0_0 \
       run.sh

EXIT_CODE=$?
if [ "$EXIT_CODE" -ne 0 ]; then
  exit $EXIT_CODE
fi

echo Backup vers $2 termine
