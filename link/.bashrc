# Bail out for non-interactive shells so ssh-driven commands (e.g. VS Code
# Remote-SSH's `ssh host sh`) keep running under their intended shell instead
# of getting exec'd into zsh, which breaks POSIX word-splitting.
case $- in
    *i*) ;;
      *) return;;
esac

# Instantly hand over the session to Zsh if available
if [[ $- == *i* ]] && command -v zsh >/dev/null 2>&1; then
    export SHELL=$(command -v zsh)
    exec "$SHELL" -l
fi

if [ -f ~/.sharedrc ]; then
  source ~/.sharedrc
fi
