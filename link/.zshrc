#!/bin/bash

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

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

# Refresh VSCODE_IPC_HOOK_CLI from tmux env on each prompt so /ide works after VS Code reconnects
function _tmux_refresh_vscode_ipc() {
  [[ -n "$TMUX" ]] && eval "$(tmux show-environment -s 2>/dev/null | grep ^VSCODE_IPC_HOOK_CLI)" 2>/dev/null || true
}
precmd_functions+=(_tmux_refresh_vscode_ipc)
