# Bail out for non-interactive shells so ssh-driven commands (e.g. VS Code
# Remote-SSH's `ssh host sh`) keep running under their intended shell instead
# of getting exec'd into zsh, which breaks POSIX word-splitting.
case $- in
    *i*) ;;
      *) return;;
esac

# Instantly hand over the session to Homebrew's Zsh
if [ -x /home/linuxbrew/.linuxbrew/bin/zsh ]; then
    export SHELL=/home/linuxbrew/.linuxbrew/bin/zsh
    exec /home/linuxbrew/.linuxbrew/bin/zsh -l
fi

if [ -f ~/.sharedrc ]; then
  source ~/.sharedrc
fi
