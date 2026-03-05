# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
    e_header "Installing Homebrew"
    (
        set -e
        NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ -d "/home/linuxbrew/.linuxbrew/bin" ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
        fi
    ) || { e_error "Homebrew installation failed."; return 1; }
fi

# Evaluate if brew is in path or in the default linuxbrew location
if [[ ! "$(type -P brew)" ]] && [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi

# Fail if Homebrew is still not available
if [[ ! "$(type -P brew)" ]]; then
    e_error "Homebrew not found in PATH."
    return 1
fi

e_header "Updating Homebrew"
# Use brew update --quiet for less noise in idempotent runs
brew update --quiet

function brew_tap_kegs() {
    local kegs=("$@")
    local current_taps
    current_taps=$(brew tap)
    local filtered_kegs=()
    for keg in "${kegs[@]}"; do
        if ! echo "$current_taps" | grep -qxF "$keg"; then
            filtered_kegs+=("$keg")
        fi
    done
    
    if (( ${#filtered_kegs[@]} > 0 )); then
        e_header "Tapping Homebrew kegs: ${filtered_kegs[*]}"
        for keg in "${filtered_kegs[@]}"; do
            brew tap "$keg"
        done
    fi
}

# Install Homebrew recipes.
function brew_install_recipes() {
    local recipes=("$@")
    local installed_recipes
    installed_recipes=$(brew list --formula)
    local filtered_recipes=()
    for recipe in "${recipes[@]}"; do
        if ! echo "$installed_recipes" | grep -qxF "$recipe"; then
            filtered_recipes+=("$recipe")
        fi
    done

    if (( ${#filtered_recipes[@]} > 0 )); then
        e_header "Installing Homebrew recipes: ${filtered_recipes[*]}"
        for recipe in "${filtered_recipes[@]}"; do
            brew install "$recipe"
        done
    fi
}
