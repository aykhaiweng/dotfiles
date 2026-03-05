#!/usr/bin/env bash

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ -d "$HOME/.oh-my-zsh/" ]]; then
    # Installing zsh-syntax-highlighting
    if [[ -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting/.git" ]]; then
        e_arrow "Updating zsh-syntax-highlighting..."
        git -C "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" pull --quiet
    else
        e_header "Installing zsh-syntax-highlighting..."
        rm -rf "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
    fi

    # Installing zsh-autosuggestions
    if [[ -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions/.git" ]]; then
        e_arrow "Updating zsh-autosuggestions..."
        git -C "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" pull --quiet
    else
        e_header "Installing zsh-autosuggestions..."
        rm -rf "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
    fi
else
    e_error "Skipping plugin installation, cannot find .oh-my-zsh in $HOME directory"
fi