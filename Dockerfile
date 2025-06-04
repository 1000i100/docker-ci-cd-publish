# https://hub.docker.com/r/oven/bun
FROM oven/bun:alpine

MAINTAINER [1000i100] Millicent Billette <git@1000i100.fr>

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
    rsync \
    openssh-client \
    ca-certificates \
    git \
    lftp \
    curlftpfs \
    fuse \
    tar \
    zip \
    bash \
    # Dependencies for Playwright browsers
    chromium \
    firefox \
    webkit2gtk \
    # Additional system dependencies for browsers
    xvfb \
    dbus \
    fontconfig \
    freetype \
    harfbuzz \
    ttf-freefont \
    wqy-zenhei \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/* \
    # Install Node.js packages globally
    && bun install -g nuekit vitest jest @vitest/browser playwright \
    # Install Playwright browsers (using system browsers on Alpine)
    && bunx playwright install-deps \
    # Set environment variables for Playwright
    && echo 'export PLAYWRIGHT_BROWSERS_PATH=/usr/bin' >> /etc/profile \
    && echo 'export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1' >> /etc/profile
