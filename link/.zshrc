# --- Where the magic happens.
export DOTFILES=~/.dotfiles

# --- Build for NODE
export LDFLAGS="-L/opt/homebrew/opt/node@14/lib"
export CPPFLAGS="-I/opt/homebrew/opt/node@14/include"

# Source all files in "source"
function src() {
    local file
    if [[ "$1" ]]; then
        source "$DOTFILES/source/$1.sh"
    else
        for file in $DOTFILES/source/*; do
            source "$file"
        done
    fi
}
src

# --- The next line updates PATH for the Google Cloud SDK.
if [ -f '/root/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/root/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# --- The next line enables shell command completion for gcloud.
if [ -f '/root/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/root/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# --- JDK stuff
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

if is_ubuntu; then
    # Linuxbrew stuff
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- Shell stuff
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# --- bat
export BAT_THEME="Catppuccin Mocha"
