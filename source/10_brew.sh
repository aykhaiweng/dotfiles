# OSX-only stuff. Abort if not OSX.
is_ubuntu || return 1

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
