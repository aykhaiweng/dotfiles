# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="wayk"

# Plugins
plugins=(
	brew
	branch
	fzf
	git
	docker
	docker-compose
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User completions
# --- The next line updates PATH for the Google Cloud SDK.
if [ -f '/root/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/root/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# --- The next line enables shell command completion for gcloud.
if [ -f '/root/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/root/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
