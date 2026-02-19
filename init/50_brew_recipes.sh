# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew casks need Homebrew to install." && return 1


# Install Homebrew recipes.
function brew_install_recipes() {
    recipes=($(setdiff "${recipes[*]}" "$(brew list)"))
    if (( ${#recipes[@]} > 0 )); then
        e_header "Installing Homebrew recipes: ${recipes[*]}"
        for recipe in "${recipes[@]}"; do
            e_arrow "Installing recipe: ${recipe}"
            brew install $recipe
        done
    fi
}

# Homebrew recipes
recipes=(
  "bat"
  "coreutils"
  "eza"
  "fd"
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

brew_install_recipes

# Misc cleanup!

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# htop
# if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" ]]; then
#   e_header "Updating htop permissions"
#   sudo chown root:wheel "$binroot/htop"
#   sudo chmod u+s "$binroot/htop"
# fi

# bash
if [[ "$(type -P $binroot/bash)" && "$(cat /etc/shells | grep -q "$binroot/bash")" ]]; then
  e_header "Adding $binroot/bash to the list of acceptable shells"
  echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
fi
# if [[ "$(dscl . -read ~ UserShell | awk '{print $2}')" != "$binroot/bash" ]]; then
#   e_header "Making $binroot/bash your default shell"
#   sudo chsh -s "$binroot/bash" "$USER" >/dev/null 2>&1
#   e_arrow "Please exit and restart all your shells."
# fi
