# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="af-magic"

# Plugins
plugins=(
	brew
	branch
	fzf
	git
    git-auto-fetch
	docker
	docker-compose
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export GPG_TTY=$(tty)

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
