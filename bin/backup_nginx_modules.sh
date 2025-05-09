#!/bin/bash

BACKUP_FOLDER="/mnt/staging/tas/backup"
BACKUP_FILE="${BACKUP_FOLDER}/nginx_modules.tar.gz"

echo -n "Backup start "; date

tar -zcf "${BACKUP_FILE}" /var/opt/millegrilles/nginx/modules
rsync --rsh "ssh -i /home/mathieu/.ssh/id_ed25519_backup" "${BACKUP_FILE}" mginstance_prive1@fs1:backup_conf

echo -n "Backup done "; date
