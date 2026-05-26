# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && echo "Brew recipes need Homebrew to install." && return 1

function brew_install_recipes() {
    local recipes=("$@")
    local installed_recipes
    installed_recipes=$(brew list --formula)
    local filtered_recipes=()

    for recipe in "${recipes[@]}"; do
        # -q (quiet), -x (exact match), -F (fixed string)
        if ! echo "$installed_recipes" | grep -qxF "$recipe"; then
            filtered_recipes+=("$recipe")
        fi
    done

    if (( ${#filtered_recipes[@]} > 0 )); then
        echo "Installing Homebrew recipes: ${filtered_recipes[*]}"
        for recipe in "${filtered_recipes[@]}"; do
            brew install "$recipe"
        done
    else
        echo "All recipes are already installed."
    fi
}

# Homebrew recipes
recipes=(
  "bat"
  "coreutils"
  "eza"
  "fd"
  "fswatch"
  "fzf"
  "gcc"
  "git-delta"
  "gnupg"
  "gnutls"
  "harfbuzz"
  "htop"
  "iperf"
  "kubernetes-cli"
  "lazydocker"
  "lazygit"
  "libffi"
  "libpq"
  "libx11"
  "lua"
  "lua@5.1"
  "luarocks"
  "make"
  "neovim"
  "node"
  "openjdk"
  "openssl@3"
  "p7zip"
  "pkgconf"
  "poppler-qt5"
  "pyenv"
  "pyenv-virtualenv"
  "qt@5"
  "ripgrep"
  "ruby"
  "rust"
  "sevenzip"
  "the_silver_searcher"
  "tmux"
  "tree"
  "tree-sitter"
  "tree-sitter-cli"
  "unzip"
  "vim"
  "webp"
  "wget"
  "zellij"
  "zsh"
)

# Pass the array to the function
brew_install_recipes "${recipes[@]}"

# Remove 'local' if not in a function
binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# bash
if [[ -f "$binroot/bash" ]] && ! grep -q "$binroot/bash" /etc/shells; then
  echo "Adding $binroot/bash to the list of acceptable shells"
  echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
fi
