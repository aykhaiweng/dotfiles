#!/usr/bin/env bash

# Installing TPM for tmux plugins
if [[ -d "$HOME/.tmux/plugins/tpm/.git" ]]; then
    e_arrow "Updating tmux tpm..."
    git -C "$HOME/.tmux/plugins/tpm" pull --quiet
else
    e_header "Downloading tpm for Tmux!"
    rm -rf "$HOME/.tmux/plugins/tpm"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" || { e_error "Failed to clone tpm."; return 1; }
fi

# Installing gitbar
if [[ -d "$HOME/.tmux-gitbar/.git" ]]; then
    e_arrow "Updating tmux-gitbar..."
    git -C "$HOME/.tmux/plugins/tmux-gitbar" pull --quiet 2>/dev/null || git -C "$HOME/.tmux-gitbar" pull --quiet
else
    e_header "Downloading tmux-gitbar"
    rm -rf "$HOME/.tmux-gitbar"
    git clone https://github.com/aurelien-rainone/tmux-gitbar.git "$HOME/.tmux-gitbar" || { e_error "Failed to clone tmux-gitbar."; return 1; }
fi

return 0
