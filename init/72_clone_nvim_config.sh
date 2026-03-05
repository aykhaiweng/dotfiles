#!/usr/bin/env bash

if [[ -d "$HOME/.config/nvim/.git" ]]; then
    e_arrow "Updating nvim config in ~/.config/nvim/..."
    git -C "$HOME/.config/nvim" pull --quiet
elif [[ -d "$HOME/.config/nvim" ]]; then
    e_arrow "~/.config/nvim/ already exists but is not a git repo, skipping."
else
    e_header "Cloning nvim config to ~/.config/nvim/..."
    git clone --depth 1 git@github.com:aykhaiweng/nvim-lua.git "$HOME/.config/nvim"
fi
