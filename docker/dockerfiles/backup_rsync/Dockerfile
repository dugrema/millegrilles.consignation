FROM alpine

RUN apk update && \
    apk add --no-cache rsync openssh

ADD scripts/* /usr/local/bin/

CMD run.sh
