#!/bin/bash

# Keep PATH entries unique; .sharedrc is sourced twice below
typeset -U path PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

if [ -f ~/.sharedrc ]; then
  source ~/.sharedrc
fi

# Theme
ZSH_THEME="example"

# Plugins
plugins=(
  branch
  brew
  direnv
  docker
  docker-compose
  fzf
  gcloud
  git
  git-auto-fetch
  pyenv
  virtualenv
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

if [ -f ~/.sharedrc ]; then
  source ~/.sharedrc
fi

export GPG_TTY=$(tty)


# Added by Antigravity CLI installer
export PATH="/Users/aykhaiweng/.local/bin:$PATH"
