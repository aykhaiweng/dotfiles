#!/usr/bin/env bash

if is_installed eza; then
  export EZA_DEFAULT_OPTS="--color=always --long --git --icons=always --group-directories-first --time-style=long-iso"

  alias ls="eza $EZA_DEFAULT_OPTS --no-user --no-permissions"
  alias ll="eza $EZA_DEFAULT_OPTS -la"
  alias llt="ll --tree"
  alias lt="ls --tree"
else
  is_osx && alias ls="ls -ACFG"
  is_ubuntu && alias ls="ls -aCF --color=auto"
  alias ll="ls -l"
fi

