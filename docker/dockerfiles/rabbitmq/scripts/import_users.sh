#!/usr/bin/env bash

FILE_PATH=/opt/rabbitmq/conf

function ajouter_usager {
  FAU_USER=$1
  rabbitmqctl add_user $FAU_USER CLEAR_ME < /dev/null
  RT_USERADD=$?
  rabbitmqctl clear_password $FAU_USER < /dev/null
}

function ajouter_usager_middleware {
  F_USER=$1
  F_VHOST=$2

  echo "Ajouter $F_USER sur nouveau vhost $F_VHOST"
  rabbitmqctl add_vhost $F_VHOST < /dev/null
  ajouter_usager $F_USER

  # Input via /dev/null pour eviter d'arreter la boucle
  rabbitmqctl set_permissions -p $F_VHOST $F_USER ".*" ".*" ".*" < /dev/null
  rabbitmqctl set_topic_permissions -p $F_VHOST $F_USER "millegrilles.middleware" ".*" ".*" < /dev/null
  rabbitmqctl set_topic_permissions -p $F_VHOST $F_USER "millegrilles.inter" ".*" ".*" < /dev/null
  rabbitmqctl set_topic_permissions -p $F_VHOST $F_USER "millegrilles.noeuds" ".*" ".*" < /dev/null
  rabbitmqctl set_topic_permissions -p $F_VHOST $F_USER "millegrilles.public" ".*" ".*" < /dev/null
}

function ajouter_usager_noeud {
  F_USER=$1
  F_VHOST=$2

  echo "Ajouter noeud $F_USER sur vhost $F_VHOST"
  ajouter_usager $F_USER

  # Input via /dev/null pour eviter d'arreter la boucle
  rabbitmqctl set_permissions -p $F_VHOST $F_USER "^amq\.gen\-.*$" "^(amq\.gen\-.*|millegrilles\.noeuds)$" "^(amq\.gen\-.*|millegrilles\.noeuds)$" < /dev/null
  rabbitmqctl set_topic_permissions -p $F_VHOST $F_USER "millegrilles.noeuds" "transaction\.nouvelle|pki\.certificat.*" "^$" < /dev/null
}

function ajouter_usager_inter {
  F_USER=$1
  F_VHOST=$2

  echo "Ajouter noeud $F_USER sur vhost $F_VHOST"
  ajouter_usager $F_USER

  # Input via /dev/null pour eviter d'arreter la boucle
  rabbitmqctl set_permissions -p $F_VHOST $F_USER "^amq\.gen\-.*$" "^(amq\.gen\-.*|millegrilles\.inter)$" "^(amq\.gen\-.*|millegrilles\.inter)$" < /dev/null
  rabbitmqctl set_topic_permissions -p $F_VHOST $F_USER "millegrilles.inter" "transaction\.nouvelle|pki\.certificat.*" "^$" < /dev/null
}

filename=$1
while IFS= read -r line; do
  IFS=';' read -r -a parametres <<< "$line"
  DOCID=${parametres[0]}
  USAGER=${parametres[1]}
  VHOST=${parametres[2]}
  ROLE=${parametres[3]}
  echo "Usager: $USAGER, Role: $ROLE"

  if [ $ROLE == "middleware" ]; then
    ajouter_usager_middleware $USAGER $VHOST
  elif [ $ROLE == "noeud" ]; then
    ajouter_usager_noeud $USAGER $VHOST
  elif [ $ROLE == "inter" ]; then
    ajouter_usager_inter $USAGER $VHOST
  fi

  echo "$DOCID;$RT_USERADD;$USAGER;$VHOST;$ROLE" >> $FILE_PATH/processed_users.txt

done < "$filename"
