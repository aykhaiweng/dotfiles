#!/usr/bin/env bash

source "$DOTFILES/source/20_pyenv.sh"

if ! is_installed pyenv; then
    e_error "pyenv not found, skipping neovim3 virtualenv setup."
    return 1
fi

# Setting up python for neovim
if pyenv virtualenvs --bare | grep -q "^neovim3$"; then
    e_arrow "Virtualenv 'neovim3' already exists."
else
    e_header "Creating virtualenv 'neovim3'..."
    pyenv virtualenv "$LATEST_PYTHON3_VERSION" neovim3 || { e_error "Failed to create neovim3 virtualenv."; return 1; }
fi

e_header "Updating pip and pynvim in 'neovim3' virtualenv"
(
    set -e
    # Use 'pyenv exec' to run pip within the virtualenv without needing to 'activate' it in the current shell
    PYENV_VERSION=neovim3 pip install -U --quiet pip neovim psutil pynvim
) || { e_error "Failed to update packages in neovim3 virtualenv."; return 1; }

e_success "Neovim Python environment configured."

# Backups, swaps and undos are stored here.
mkdir -p "$DOTFILES/caches/vim"
