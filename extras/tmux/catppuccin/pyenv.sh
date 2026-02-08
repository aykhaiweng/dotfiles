#!/bin/bash
# pyenv.sh - Custom Catppuccin module for pyenv

# Define colors (using Catppuccin Blue/Yellow convention)
# Note: $1 is the index provided by the plugin
show_pyenv() {
    local index=$1
    local icon="󱔎 " # Python icon (requires Nerd Font)
    local version=$(pyenv version-name)

    # Use the Catppuccin helper function to build the module
    # Format: module_name, index, icon, color, text
    local module=$(build_status_module "pyenv" "$index" "$icon" "blue" "$version")

    echo "$module"
}
