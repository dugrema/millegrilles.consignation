# Fichier qui genere une image docker qui va avoir des certificats
# de test integres.

FROM registry.maple.mdugre.info:5000/mg_rabbitmq.x86_64:3.7-management_5

COPY . /opt/rabbitmq/dist

RUN /opt/rabbitmq/dist/setup.sh
