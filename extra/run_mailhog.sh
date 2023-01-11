#!/usr/bin/env sh

# Requires Docker

docker run \
    --name mailhog \
    -p 1025:1025 \
    -p 8025:8025 \
    mailhog/mailhog
