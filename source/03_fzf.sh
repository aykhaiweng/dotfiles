#!/usr/bin/env bash

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/fzf-git.sh/fzf-git.sh ] && source ~/fzf-git.sh/fzf-git.sh

if [[ -d $HOME/.fzf ]]; then
    export FZF_EZA_OPTS="--tree --color=always --long --git --icons=always --no-user --no-permissions --group-directories-first {} | head -200"
    export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --no-ignore --exclude .git"
    export FZF_DEFAULT_OPTS="--height 50% --border=rounded --inline-info --layout=reverse"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview \"bat --style=numbers --color=always --line-range :500 {}\""
    export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --no-ignore --exclude .git"
    export FZF_ALT_C_OPTS="--preview \"eza --tree --color=always {} | head -200\""

    _fzf_comprun() {
        local command=$1
        shift

        case "$command" in
            cd)             fzf --preview "eza $FZF_EZA_OPTS" "$@" ;;
            export|unset)   fzf --preview "eval \"echo \$\" {}" "$@" ;;
            ssh)            fzf --preview "dig {}" "$@" ;;
            *)              fzf --preview "$FZF_CTRL_T_OPTS" "$@" ;;
        esac
    }
fi