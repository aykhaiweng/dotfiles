# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

if [[ -z "$HOMEBREW_PREFIX" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi
