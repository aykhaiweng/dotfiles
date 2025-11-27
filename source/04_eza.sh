#!/usr/bin/env bash

export EZA_DEFAULT_OPTS="--color=always --long --git --icons=always --group-directories-first --time-style=long-iso"

alias ls="eza $EZA_DEFAULT_OPTS --no-user --no-permissions"
alias ll="eza $EZA_DEFAULT_OPTS -la"
alias llt="ll --tree"
alias lt="ls --tree"