#!/usr/bin/env bash

PATH_REDMINE_FILES="/mnt/staging/redmine_files"
PATH_FILE_BACKUP_DATABASE="/mnt/staging/millegrilles_backup/redmine_mariadb/backup.redmine.mariadb.sql"
PATH_DESTINATION_BACKUP="/mnt/staging/redmine_files/backup"

mkdir -p $PATH_DESTINATION_BACKUP
chmod 775 $PATH_DESTINATION_BACKUP

# Path des scripts deja montes dans le container
PATH_SCRIPTS_CONTAINER="/var/opt/millegrilles_scripts"

SCRIPT_BACKUP="${PATH_SCRIPTS_CONTAINER}/script.redmine.mariadb.backup.sh"

echo -n "Backup start "; date

# Identifier id du container mariadb
CONTAINER_MARIADB=`docker container ls -f name=redmine_mariadb -q`

docker exec ${CONTAINER_MARIADB} "${SCRIPT_BACKUP}"

if [ $? -ne 0 ]; then
  echo "Error running backup in docker"
  exit 1
fi

# Copier fichiers du volume redmine_files
cd "$PATH_DESTINATION_BACKUP"
cp "${PATH_FILE_BACKUP_DATABASE}" .
if [ $? -ne 0 ]; then
  echo "Copying database backup file"
  exit 2
fi

echo "Backup redmine files from ${PATH_REDMINE_FILES}"
# REDMINE_DATE_FOLDERS=`ls ${PATH_REDMINE_FILES}/20*`
echo "Backup folders under ${PATH_REDMINE_FILES}: ${REDMINE_DATE_FOLDERS}"
time nice -n 5 tar --directory=${PATH_REDMINE_FILES} --sort=name -Jcf redmine.backup.tar.xz.work backup/backup.redmine.mariadb.sql --exclude backup --exclude work .
if [ $? -ne 0 ]; then
  echo "Error creating TAR archive"
  exit 3
fi

rotation_fichiers.sh redmine.backup.tar.xz
mv -f redmine.backup.tar.xz.work redmine.backup.tar.xz
if [ $? -ne 0 ]; then
  echo "Error moving redmine tar file"
  exit 4
fi

# Sync to remote backup server
echo "Rsync to fs1"
ls -l redmine.backup.tar.xz

rsync --rsh "ssh -i /home/mathieu/.ssh/id_ed25519_backup" \
redmine.backup.tar.xz \
mginstance_prive1@fs1:redmine

rm -f "$PATH_DESTINATION_BACKUP/backup.redmine.mariadb.sql.bak"
mv "$PATH_DESTINATION_BACKUP/backup.redmine.mariadb.sql" "$PATH_DESTINATION_BACKUP/backup.redmine.mariadb.sql.bak"

echo -n "Backup done "; date

