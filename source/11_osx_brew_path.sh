#!/usr/bin/env bash

is_osx || return 1

export PATH="/opt/homebrew/bin:$PATH"

# libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"
# export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

# openssl
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"

# To get clang to work
# export ARCHFLAGS="-arch x86_64"
