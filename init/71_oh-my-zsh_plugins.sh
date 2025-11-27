#!/usr/bin/env bash

if [[ -d "$HOME/.oh-my-zsh/" ]]; then
    # Installing zsh-syntax-highlighting
    if [[ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
        e_arrow "zsh-syntax-highlighting is already installed"
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi

    if [[ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
        e_arrow "zsh-autosuggestions is already installed"
    else
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
else
    e_arrow "Skipping plugin installation, cannot find .oh-my-zsh in $HOME directory"
fi