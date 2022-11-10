#!/usr/bin/env sh

# Requires Docker

docker run \
    --name postgres \
    -p 5432:5432 \
    -v "$HOME/mounts/postgres/:/var/lib/postgresql/data/" \
    -e POSTGRES_PASSWORD="b0g3nblaht0pk3k" \
    -e POSTGRES_USER="aykhaiweng" \
    -e POSTGRES_DB="aykhaiweng" \
    postgres:alpine
