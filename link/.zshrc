#!/bin/bash

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

if [ -f ~/.sharedrc ]; then
  source ~/.sharedrc
fi

export GPG_TTY=$(tty)

# Refresh VSCODE_IPC_HOOK_CLI from tmux env on each prompt so /ide works after VS Code reconnects
function _tmux_refresh_vscode_ipc() {
  if [[ -n "$TMUX" && -z "$VSCODE_IPC_HOOK_CLI" ]]; then
    eval "$(tmux show-environment -s 2>/dev/null | grep ^VSCODE_IPC_HOOK_CLI)" 2>/dev/null || true
  fi
}
precmd_functions+=(_tmux_refresh_vscode_ipc)
