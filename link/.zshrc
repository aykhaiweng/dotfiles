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

# Refresh VSCODE_IPC_HOOK_CLI and TERM_PROGRAM from tmux env on each prompt.
# Needed because tmux 3.4+ injects TERM_PROGRAM=tmux into all panes, breaking Gemini /ide.
function _tmux_refresh_vscode_ipc() {
  if [[ -n "$TMUX" ]]; then
    [[ -z "$VSCODE_IPC_HOOK_CLI" ]] && eval "$(tmux show-environment -s 2>/dev/null | grep ^VSCODE_IPC_HOOK_CLI)" 2>/dev/null || true
    [[ "$TERM_PROGRAM" != "vscode" && "$(tmux show-environment TERM_PROGRAM 2>/dev/null)" == "TERM_PROGRAM=vscode" ]] && export TERM_PROGRAM=vscode
  fi
}
precmd_functions+=(_tmux_refresh_vscode_ipc)


# Added by Antigravity CLI installer
export PATH="/Users/aykhaiweng/.local/bin:$PATH"
