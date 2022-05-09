CONTAINER=814bc2dba323
PATH_PASSWD=/var/opt/millegrilles/secrets/passwd.redis.20220507194334

PASSWORD=`cat $PATH_PASSWD`

echo Utiliser "auth client_nodejs $PASSWORD"

docker exec -it $CONTAINER redis-cli \
  --tls --cacert /run/secrets/millegrille.cert.pem --cert /run/secrets/cert.pem --key /run/secrets/key.pem

# Executer login default avec password
