#!/usr/bin/env bash

if [[ -d $HOME/.config/nvim ]]; then
    e_arrow "~/.config/nvim/ already exists"
else
    e_success "Cloning nvim config to ~/.config/nvim/"
    git clone --depth 1 git@github.com:aykhaiweng/nvim-lua.git $HOME/.config/nvim
fi
