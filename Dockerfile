# https://hub.docker.com/_/alpine/
FROM alpine:latest

MAINTAINER [1000i100] Millicent Billette <git@1000i100.fr>


RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
            rsync \
            openssh-client \
            ca-certificates \
            git \
            lftp \
            bash \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*
