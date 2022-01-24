FROM golang:1.17.6-alpine

RUN apk add --no-cache bash \
	curl \
	docker-cli \
	docker-cli-buildx \
	git \
	mercurial \
	make \
	build-base \

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY static-ws /bin/static-ws

ENTRYPOINT ["/entrypoint.sh"]
