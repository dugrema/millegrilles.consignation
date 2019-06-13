#!/usr/bin/env bash

function ajouter_usager {
  FAU_USER=$1
  rabbitmqctl add_user $FAU_USER CLEAR_ME < /dev/null
  RT_USERADD=$?
  rabbitmqctl clear_password $FAU_USER < /dev/null
}

function ajouter_usager_noeud {
  F_USER=$1
  F_VHOST=$2

  echo "Ajouter noeud $F_USER sur vhost $F_VHOST"
  ajouter_usager $F_USER

  # Input via /dev/null pour eviter d'arreter la boucle
  rabbitmqctl set_permissions -p $F_VHOST $F_USER "^amq\.gen\-.*$" "^amq\.gen\-.*$" "^(amq\.gen\-.*|millegrilles\.noeuds)$" < /dev/null
  rabbitmqctl set_topic_permissions -p $F_VHOST $F_USER "millegrilles.noeuds" "nouvelle\.transaction" "topic\.test" < /dev/null
}

function ajouter_usager_inter {
  F_USER=$1
  F_VHOST=$2

  echo "Ajouter noeud $F_USER sur vhost $F_VHOST"
  ajouter_usager $F_USER

  # Input via /dev/null pour eviter d'arreter la boucle
  rabbitmqctl set_permissions -p $F_VHOST $F_USER "^amq\.gen\-.*$" "^amq\.gen\-.*$" "^(amq\.gen\-.*|millegrilles\.inter)$" < /dev/null
  rabbitmqctl set_topic_permissions -p $F_VHOST $F_USER "millegrilles.inter" "nouvelle\.transaction" "topic\.test" < /dev/null
}

filename=$1
while IFS= read -r line; do
  IFS=';' read -r -a parametres <<< "$line"
  USAGER=${parametres[0]}
  VHOST=${parametres[1]}
  ROLE=${parametres[2]}
  echo "Usager: $USAGER, Role: $ROLE"

  if [ $ROLE == "noeud" ]; then
    ajouter_usager_noeud $USAGER $VHOST
  elif [ $ROLE == "inter" ]; then
    ajouter_usager_inter $USAGER $VHOST
  fi

  if [ $RT_USERADD -eq 0 ] || [ $RT_USERADD -eq 70 ]; then
    echo "$USAGER;$VHOST;$ROLE" >> processed_users.txt
  fi

done < "$filename"
