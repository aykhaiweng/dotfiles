#!/usr/bin/env bash

# Install oh-my-zsh if it's not already installed
if [[ -d "$HOME/.oh-my-zsh/" ]]; then
    e_arrow "oh-my-zsh is already installed"
else
    e_arrow "Setting KEEP_ZSHRC=yes"
    export KEEP_ZSHRC=yes
    e_arrow "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    e_success "oh-my-zsh installed."
fi

return 1
