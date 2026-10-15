#!/usr/bin/env bash

# Language servers that Claude Code's LSP plugins run. marksman comes from
# 50_brew_recipes.sh; the npm-based ones are installed here.
if ! is_installed npm; then
    e_error "npm is not installed, skipping language servers."
    return 1
fi

e_header "Installing language servers"
npm_servers=(
  "typescript-language-server:typescript-language-server typescript"
  "bash-language-server:bash-language-server"
)
for entry in "${npm_servers[@]}"; do
    bin="${entry%%:*}"
    if is_installed "$bin"; then
        e_arrow "$bin already installed."
    else
        # shellcheck disable=SC2086 # package list is meant to split
        npm i -g ${entry#*:} || { e_error "Failed to install $bin."; return 1; }
    fi
done

if ! is_installed claude; then
    e_error "claude is not installed, skipping LSP plugins."
    return 1
fi

e_header "Registering Claude Code LSP plugins"
if ! claude plugin marketplace list 2>/dev/null | grep -qw "dotfiles"; then
    claude plugin marketplace add "$DOTFILES/claude-plugins" \
        || { e_error "Failed to add the dotfiles marketplace."; return 1; }
fi

installed_plugins=$(claude plugin list 2>/dev/null)
for plugin in \
    "typescript-lsp@claude-plugins-official" \
    "marksman-lsp@dotfiles" \
    "bash-lsp@dotfiles"; do
    if echo "$installed_plugins" | grep -qF "$plugin"; then
        e_arrow "$plugin already installed."
    else
        claude plugin install "$plugin" || { e_error "Failed to install $plugin."; return 1; }
    fi
done

e_success "Language servers configured."
