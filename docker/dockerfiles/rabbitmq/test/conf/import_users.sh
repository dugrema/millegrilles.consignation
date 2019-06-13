#!/usr/bin/env bash

function ajouter_usager_noeud {
  F_USER=$1
  F_VHOST=$2
  echo "Ajouter noeud $F_USER sur vhost $F_VHOST"

  # Input via /dev/null pour eviter d'arreter la boucle
  rabbitmqctl add_user $F_USER CLEAR_ME < /dev/null
  rabbitmqctl clear_password $F_USER < /dev/null
  rabbitmqctl set_permissions -p $F_VHOST $F_USER "^amq\.gen\-.*$" "^amq\.gen\-.*$" "^(amq\.gen\-.*|millegrilles\.evenements)$" < /dev/null
  rabbitmqctl set_topic_permissions -p $F_VHOST $F_USER "millegrilles.noeuds" "nouvelle\.transaction" "topic\.test" < /dev/null
}

function ajouter_usager_inter {
  echo "Ajouter inter $1 sur vhost $2"
  # rabbitmqctl set_permissions -p sansnom lecteur_1 "^amq\.gen\-.*$" "^amq\.gen\-.*$" "^(amq\.gen\-.*|millegrilles\.evenements)$"
  # rabbitmqctl set_topic_permissions -p sansnom lecteur_1 "millegrilles.evenements" "" "topic\.test"
}

filename=$1
while IFS= read -r line; do
  IFS=' ' read -r -a parametres <<< "$line"
  USAGER=${parametres[0]}
  VHOST=${parametres[1]}
  ROLE=${parametres[2]}
  echo "Usager: $USAGER, Role: $ROLE"

  if [ $ROLE == "noeud" ]; then
    ajouter_usager_noeud $USAGER $VHOST
  elif [ $ROLE == "inter" ]; then
    ajouter_usager_inter $USAGER $VHOST
  fi

done < "$filename"
