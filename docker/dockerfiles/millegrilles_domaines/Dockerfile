# Image pour scripts python MilleGrilles domaines
# Note: les fichiers doivent avoir ete copies dans le repertoire courant sous src/

FROM registry.maple.mdugre.info:5000/millegrilles_consignation_python:v0.2.1

COPY src/ ./

CMD ["millegrilles/script_demarrergestionnaire.py", "-m", "mgdomaines.appareils.SenseursPassifs", "-c", "GestionnaireSenseursPassifs"]

