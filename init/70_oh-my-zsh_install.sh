#!/usr/bin/env bash

# Install oh-my-zsh if it's not already installed
if [[ -d "$HOME/.oh-my-zsh/" ]]; then
    e_arrow "oh-my-zsh is already installed"
else
    e_header "Installing oh-my-zsh..."
    (
        set -e
        export KEEP_ZSHRC=yes
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ) || { e_error "oh-my-zsh installation failed."; return 1; }
    e_success "oh-my-zsh installed successfully."
fi
