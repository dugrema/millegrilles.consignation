if [ -z $1 ]; then
  echo "Il faut fournir le prefixe IPv6"
  exit -1
fi

PREFIX=$1

docker network create \
       --driver=bridge \
       --attachable \
       --subnet=172.20.0.0/16 \
       --gateway=172.20.0.1 \
       --ipv6 --subnet=$PREFIX::/80 \
       ipv6_bridge

