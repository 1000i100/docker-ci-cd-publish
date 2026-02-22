# https://hub.docker.com/r/oven/bun
FROM oven/bun:alpine

MAINTAINER [1000i100] Millicent Billette <git@1000i100.fr>

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
    nodejs-current npm \
    lcov \
    rsync \
    openssh-client ca-certificates \
    git \
    lftp \
    tar zip \
    bash \
    chromium firefox \
    xvfb \
    dbus \
    fontconfig freetype ttf-freefont \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/* \
    && bun install -g vitest jest @vitest/browser playwright nuekit


ENV PLAYWRIGHT_BROWSERS_PATH=/usr/bin
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV DISPLAY=:99
