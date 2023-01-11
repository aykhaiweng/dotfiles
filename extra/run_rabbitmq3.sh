#!/usr/bin/env sh

# Requires Docker

docker run \
    --name rabbitmq \
    -p 5672:5672 \
    -p 15672:15672 \
    -p 15692:15692 \
    -v "$HOME/mounts/rabbitmq/:/var/lib/rabbitmq/mnesia/" \
    -e RABBITMQ_DEFAULT_USER="user" \
    -e RABBITMQ_DEFAULT_PASS="password" \
    rabbitmq:3-management-alpine
