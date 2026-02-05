#!/usr/bin/env bash

if [[ $(pyenv versions | grep $LATEST_PYTHON3_VERSION) ]]; then
    e_arrow "Python $LATEST_PYTHON3_VERSION already installed."
else
    e_arrow "Installing Python $LATEST_PYTHON3_VERSION."
    # Install the latest version of Python
    pyenv install $LATEST_PYTHON3_VERSION
    pyenv global $LATEST_PYTHON3_VERSION
    pip install -U pip
    e_success "Python $LATEST_PYTHON3_VERSION installed!"
fi
