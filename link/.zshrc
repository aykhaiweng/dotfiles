#!/bin/bash

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="example"

# Plugins
plugins=(
  branch
  brew
  docker
  docker-compose
  fzf
  git
  git-auto-fetch
  pyenv
  virtualenv
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

export GPG_TTY=$(tty)
