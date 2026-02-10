#!/usr/bin/env bash

source "$DOTFILES/source/20_pyenv.sh"

# Setting up python for neovim
if [[ $(pyenv versions | grep neovim3) ]]; then
    e_arrow "Virtualenv for neovim3 already exists"
else
    e_arrow "Creating virtualenv for neovim3"
    pyenv virtualenv $LATEST_PYTHON3_VERSION neovim3
fi

e_arrow "Setting up virtualenv for Neovim"
e_arrow "Activating neovim3 virtualenv"
pyenv activate neovim3
e_arrow "Installing pip in neovim3 virtualenv"
pip install -U pip neovim psutil pynvim
e_arrow "Exiting neovim3 virtualenv"
pyenv deactivate

# Backups, swaps and undos are stored here.
mkdir -p $DOTFILES/caches/vim
