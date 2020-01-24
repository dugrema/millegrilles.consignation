FROM node:12

# Create app directory
WORKDIR /usr/src/app

# Volume pour le staging des fichiers uploades via coupdoeil
VOLUME /opt/millegrilles/consignation

ENV MG_NOM_MILLEGRILLE=sansnom \
    MG_CONSIGNATION_PATH=/opt/millegrilles/consignation \
    PORT=443 \
    HOST=consignationfichiers \
    PRIVKEY=/run/secrets/pki.millegrilles.ssl.key \
    CERT=/run/secrets/pki.millegrilles.ssl.cert

EXPOSE 443

CMD [ "npm", "start" ]

# Installer ffmpeg, imagemagick pour conversion video et images
RUN apt update && \
    apt install ffmpeg imagemagick-6.q16 -y && \
    apt clean && \
    rm -rf /var/cache/apt
