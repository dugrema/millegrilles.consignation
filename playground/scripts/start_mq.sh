
rabbitmq-plugins enable --offline rabbitmq_auth_mechanism_ssl
cp /certs/rabbitmq.config /etc/rabbitmq

docker-entrypoint.sh rabbitmq-server

