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

# ==> Source [/home/linuxbrew/.linuxbrew/Caskroom/gcloud-cli/556.0.0/google-cloud-sdk/completion.zsh.inc] in your profile to enable shell command completion for gcloud.
# ==> Source [/home/linuxbrew/.linuxbrew/Caskroom/gcloud-cli/556.0.0/google-cloud-sdk/path.zsh.inc]
#  in your profile to add the Google Cloud SDK command line tools to your $PATH.

# User completions
# --- The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/linuxbrew/.linuxbrew/Caskroom/gcloud-cli/556.0.0/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/linuxbrew/.linuxbrew/Caskroom/gcloud-cli/556.0.0/google-cloud-sdk/completion.zsh.inc'; fi

# --- The next line enables shell command completion for gcloud.
if [ -f '/home/linuxbrew/.linuxbrew/Caskroom/gcloud-cli/556.0.0/google-cloud-sdk/path.zsh.inc' ]; then . '/home/linuxbrew/.linuxbrew/Caskroom/gcloud-cli/556.0.0/google-cloud-sdk/path.zsh.inc'; fi

export GPG_TTY=$(tty)

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
