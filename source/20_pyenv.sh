#!/usr/bin/env bash

# Enable configuration options for Python
is_osx && export PYTHON_CONFIGURE_OPTS="--enable-framework"
is_ubuntu && export PYTHON_CONFIGURE_OPTS="--enable-shared"

export LATEST_PYTHON3_VERSION=3.14.3

if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
