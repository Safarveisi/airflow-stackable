FROM alpine:3.13

LABEL maintainer="sajad.safarveisi@gmail.com"

RUN apk update && apk add --no-cache python py-pip py-setuptools ca-certificates libmagic \
    && pip install --no-cache-dir s3cmd==2.4.0 && \
    rm -rf /var/cache/apk/*

RUN addgroup -g 118 mygroup && adduser -D -u 1001 -G mygroup myuser

COPY ./entrypoint.sh /opt/s3cmd/entrypoint.sh
COPY ./.s3cfg .s3cfg

RUN chmod +x /opt/s3cmd/entrypoint.sh

WORKDIR /github/home

USER myuser

ENTRYPOINT ["/opt/s3cmd/entrypoint.sh"]
