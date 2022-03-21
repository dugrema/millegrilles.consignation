FROM redis:6.2

COPY redis.conf /usr/local/etc/
COPY creer_acl.sh start.sh connect.sh /usr/local/bin/

RUN mkdir /home/redis && \
    chown redis:1000 /home/redis && \
    chmod 700 /home/redis

CMD ["start.sh"]
