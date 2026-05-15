# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# export HOMEBREW_CACHE="/mnt/packages/linuxbrew-cache"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
