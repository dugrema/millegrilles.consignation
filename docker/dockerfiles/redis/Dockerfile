FROM redis:8.0.2-alpine

COPY redis.conf /usr/local/etc/
COPY creer_acl.sh start.sh connect.sh /usr/local/bin/

# RUN mkdir /home/redis && \
#     chown redis:1000 /home/redis && \
#     chmod 700 /home/redis

CMD ["start.sh"]
