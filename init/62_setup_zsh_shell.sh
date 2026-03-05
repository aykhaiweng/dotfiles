#!/usr/bin/env bash

# Check if zsh is actually installed first
if ! is_installed zsh; then
    e_error "zsh is not installed on this system."
    return 1
fi

ZSH_PATH=$(command -v zsh)

# Add to /etc/shells if not already there
if grep -Fxq "$ZSH_PATH" /etc/shells; then
    e_arrow "$ZSH_PATH is already in /etc/shells"
else
    e_header "Adding $ZSH_PATH to /etc/shells"
    echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
    e_success "Added $ZSH_PATH to /etc/shells"
fi

# Change shell to zsh if not already zsh
if [[ "$SHELL" == "$ZSH_PATH" ]]; then
    e_arrow "Shell is already $ZSH_PATH"
else
    e_header "Changing shell to $ZSH_PATH"
    sudo chsh -s "$ZSH_PATH" "${USER}"
    e_success "Shell changed to $ZSH_PATH"
fi

return 1

