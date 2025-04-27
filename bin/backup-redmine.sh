#!/usr/bin/env bash

PATH_REDMINE_FILES="/mnt/staging/redmine_files"
PATH_FILE_BACKUP_DATABASE="/mnt/staging/millegrilles_backup/redmine_mariadb/backup.redmine.mariadb.sql"
PATH_DESTINATION_BACKUP="/mnt/staging/redmine_files/backup"

# Path des scripts deja montes dans le container
PATH_SCRIPTS_CONTAINER="/var/opt/millegrilles_scripts"

SCRIPT_BACKUP="${PATH_SCRIPTS_CONTAINER}/script.redmine.mariadb.backup.sh"

echo -n "Backup start "; date

# Identifier id du container mariadb
CONTAINER_MARIADB=`docker container ls -f name=redmine_mariadb -q`

docker exec ${CONTAINER_MARIADB} "${SCRIPT_BACKUP}"

# Copier fichiers du volume redmine_files
cd "$PATH_DESTINATION_BACKUP"
cp "${PATH_FILE_BACKUP_DATABASE}" .

echo "Backup redmine files from ${PATH_REDMINE_FILES}"
tar -Jcf redmine.backup.tar.xz.work backup.redmine.mariadb.sql ${PATH_REDMINE_FILES}/20*
rotation_fichiers.sh redmine.backup.tar.xz
mv redmine.backup.tar.xz.work redmine.backup.tar.xz

# Sync to remote backup server
echo "Rsync to fs1"
ls -l redmine.backup.tar.xz

rsync --rsh "ssh -i /home/mathieu/.ssh/id_ed25519_backup" \
redmine.backup.tar.xz \
mginstance_prive1@fs1:redmine

echo -n "Backup done "; date

