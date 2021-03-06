#!/usr/bin/env bash

if [[ -d $HOME/.fzf ]]; then
    export FZF_DEFAULT_COMMAND="ag --ignore '*.pyc' --ignore '*/*.pyc' --ignore-dir '*pycache*' --ignore-dir '.tox' --hidden --skip-vcs-ignores -g ''"
    export FZF_DEFAULT_OPTS='--height 50% --border=rounded --inline-info --layout=reverse'
    export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --color=always --line-range :100 {}"'
fi
