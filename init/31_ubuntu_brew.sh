# OSX-only stuff. Abort if not OSX.
is_ubuntu || return 1

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
    e_header "Installing Homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Evaulate
[[ ! "$(type -P brew)" ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

# Exit if, for some reason, Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Homebrew failed to install." && return 1

e_header "Updating Homebrew"
brew doctor
brew update

function brew_tap_kegs() {
    kegs=($(setdiff "${kegs[*]}" "$(brew tap)"))
    if (( ${#kegs[@]} > 0 )); then
        e_header "Tapping Homebrew kegs: ${kegs[*]}"
        for keg in "${kegs[@]}"; do
            brew tap $keg
        done
    fi
}

# Install Homebrew recipes.
function brew_install_recipes() {
    recipes=($(setdiff "${recipes[*]}" "$(brew list)"))
    if (( ${#recipes[@]} > 0 )); then
        e_header "Installing Homebrew recipes: ${recipes[*]}"
        for recipe in "${recipes[@]}"; do
            brew install $recipe
        done
    fi
}
