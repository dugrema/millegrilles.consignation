# CONTAINER=c224bf68bf64
CONTAINER=`docker container ls --filter name=redis -q`
#PATH_PASSWD=/var/opt/millegrilles/secrets/passwd.redis.20220518115418
PATH_PASSWD=/home/mathieu/mgdev/certs/passwd.redis

PASSWORD=`cat $PATH_PASSWD`

echo Utiliser:
echo "auth client_nodejs $PASSWORD"

docker exec -it $CONTAINER redis-cli \
  --tls --cacert /run/secrets/millegrille.cert.pem --cert /run/secrets/cert.pem --key /run/secrets/key.pem

# Executer login default avec password
