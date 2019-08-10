#!/usr/bin/env bash
if [ -z $NOM_MILLEGRILLE ]; then
  echo "Il faut fournir le parametre NOM_MILLEGRILLE"
  exit 1
fi

MG_ETC_PATH=/opt/millegrilles/$NOM_MILLEGRILLE/etc
FICHIER_CONF=$MG_ETC_PATH/ipv6_local.txt

# Generer le nom et adresse locale des services
NOM_CONTAINERS=( \
  nginxlocal \
  coupdoeilreact \
  mq \
  mongoexpress \
)

trouver_network_dev() {
  if [ -z $INTERFACES ]; then
    # Trouver tous les devices physiques actifs.
    # On utilise qlen pour determiner les interfaces physiques.
    DEVICES=`ip -6 a show scope link up | grep qlen | awk 'BEGIN{FS=": "}; {print $2}'`

    if [ -z $DEVICES ]; then
      echo "L'interface reseau n'est pas detectee. Fournir INTERFACE en parametre"
      exit 2
    fi

    export INTERFACES=$DEVICES
  fi
}

generer_local_address() {
  LOCAL_PREFIX=fe80::28
  export IPV6ADDR=$(echo $1|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*/fe80::28\1:\2\3\:4\5:\6\7/')
}

generer_adresses() {
  for NOM_CONTAINER in ${NOM_CONTAINERS[@]}; do
    NOM_COMPLET=millegrilles-${NOM_MILLEGRILLE}_$NOM_CONTAINER.1
    generer_local_address $NOM_COMPLET
    echo \[\"$NOM_COMPLET\"\]=\"$IPV6ADDR\" \\ >> $FICHIER_CONF
  done
}

echo \# Fichier de configuration pour docker_ipv6_staticset.sh > $FICHIER_CONF
trouver_network_dev
echo INTERFACES=$INTERFACES >> $FICHIER_CONF
echo NOM_RESEAU=ipv6_bridge_link >> $FICHIER_CONF

echo declare -A CONTAINER_IPS >> $FICHIER_CONF
echo CONTAINER_IPS=\( \\ >> $FICHIER_CONF
generer_adresses
echo \) >> $FICHIER_CONF
