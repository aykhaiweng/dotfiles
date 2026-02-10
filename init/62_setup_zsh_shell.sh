#!/usr/bin/env bash

ZSH_PATH=$(command -v zsh)

# Check if zsh is actually installed first
if [ -z "$ZSH_PATH" ]; then
    echo "Error: zsh is not installed on this system."
    exit 1
fi


if grep -Fxq "$ZSH_PATH" /etc/shells; then
    e_arrow "$ZSH_PATH is already in /etc/shells"
else
    command -v zsh | sudo tee -a /etc/shells
    sudo chsh -s "$(command -v zsh)" "${USER}"
    e_success "$ZSH_PATH added to /etc/shells"
fi

return 1
