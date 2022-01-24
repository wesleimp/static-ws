FROM golang:alpine

RUN apk add --no-cache bash curl docker-cli git mercurial make

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY static-ws /bin/static-ws

ENTRYPOINT ["/entrypoint.sh"]
