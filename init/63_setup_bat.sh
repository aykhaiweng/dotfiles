#!/usr/bin/env bash

if ! is_installed bat; then
    e_error "bat is not installed, skipping theme setup."
    return 1
fi

BAT_CONFIG_DIR=$(bat --config-dir)
THEME_DIR="$BAT_CONFIG_DIR/themes"

mkdir -p "$THEME_DIR"

e_header "Downloading Catppuccin themes for bat"
(
    set -e
    for theme in "Latte" "Frappe" "Macchiato" "Mocha"; do
        wget -q -N -P "$THEME_DIR" "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20${theme}.tmTheme"
    done
    bat cache --build
) || { e_error "Failed to setup bat themes."; return 1; }

e_success "bat themes configured."
