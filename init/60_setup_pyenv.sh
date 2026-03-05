#!/usr/bin/env bash

# Source pyenv configuration for context
source "$DOTFILES/source/20_pyenv.sh"

if ! is_installed pyenv; then
    e_error "pyenv is not installed. Please install it first."
    return 1
fi

if pyenv versions --bare | grep -q "^${LATEST_PYTHON3_VERSION}$"; then
    e_arrow "Python $LATEST_PYTHON3_VERSION is already installed."
else
    e_header "Installing Python $LATEST_PYTHON3_VERSION..."
    (
        set -e
        pyenv install "$LATEST_PYTHON3_VERSION"
        pyenv global "$LATEST_PYTHON3_VERSION"
        pip install -U pip
    ) || { e_error "Failed to install Python $LATEST_PYTHON3_VERSION."; return 1; }
    e_success "Python $LATEST_PYTHON3_VERSION installed successfully!"
fi
