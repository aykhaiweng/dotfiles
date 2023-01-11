#!/usr/bin/env sh

# Requires Docker

docker run \
    --name postgres \
    -p 5432:5432 \
    -v "$HOME/mounts/postgres/:/var/lib/postgresql/data/" \
    -e POSTGRES_PASSWORD="postgres" \
    -e POSTGRES_USER="postgres" \
    -e POSTGRES_DB="postgres" \
    postgres:15-alpine
