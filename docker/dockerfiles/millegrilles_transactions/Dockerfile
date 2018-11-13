# Image pour scripts python millegrilles.transaction
# Note: les fichiers doivent avoir ete copies dans le repertoire courant sous src/

FROM python:3.7

WORKDIR /usr/src/app

ENV PYTHONPATH /usr/src/app

# Variables d'environnement
ENV MG_MQ_HOST rabbitmq
ENV MG_MONGO_HOST mongo

COPY src/ ./
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/usr/bin/python3"]
CMD ["millegrilles/consignation/ConsignateurTransaction.py"]

