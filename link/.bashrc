# Instantly hand over the session to Homebrew's Zsh
if [ -x /home/linuxbrew/.linuxbrew/bin/zsh ]; then
    export SHELL=/home/linuxbrew/.linuxbrew/bin/zsh
    exec /home/linuxbrew/.linuxbrew/bin/zsh -l
fi

if [ -f ~/.sharedrc ]; then
  source ~/.sharedrc
fi
