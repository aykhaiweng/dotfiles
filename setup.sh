#!/bin/bash

_echo() {
	echo "[aykhaiweng says] - $1"
}

main() {
	# prompt for sudo
	_echo "Before I start installing anything, I'm going to need your password for sudo access."
	sudo -v

	# declare variable for os type
	uname=$(uname)

	_echo "$uname detected."

	if [[ $uname == 'Darwin' ]]; then
		_echo "Setting up for Darwin platform."
		source osx/setup-osx.sh
	elif [[ $uname == 'Linux' ]]; then
		_echo "Setting up for Linux platform."
		source linux/setup-linux.sh
	else
		_echo "Your platform is not supported yet."
	fi

	# updating pip and it's prerequisites
	_echo "Upgrading pip and installing prerequisites."
	sudo pip3 install --upgrade pip
	sudo pip3 install django django-debug-toolbar Pillow psycopg2 ipython coverage
	echo

	# prepare to symlink the files
	_echo "Now preparing to symlink files."
	python3 symlink.py

	# run the aliases file to get the pyenv out
	source $HOME/.aliases


	# ZSH STUFF
	# set zsh as default
	if [[ $SHELL != '/bin/zsh' ]]; then
		_echo "Current shell is `$SHELL`, changing to `/bin/zsh`"
		chsh -s $(which zsh)
	fi


	# VIM STUFF
	# installing Vundle
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


	# installing pyenv 3.6.4 and 2.7.13
	yes '' | pyenv install 3.6.4
	yes '' | pyenv install 2.7.13

	# install vim plugins
	vim -c 'PluginInstall' -c 'qa!'

	# install ycm from vim plugins
	python $HOME/.vim/bundle/YouCompleteMe/install.py

	# now we install .oh-my-zsh
	yes '' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


	# SSH STUFF
	# create an id_rsa file if it doesn't already exist
	if [ ! -f $HOME/.ssh/id_rsa ]; then
		ssh-keygen -f id_rsa -t rsa -N ''
		_echo "A ssh-key with the default name (~/.ssh/id_rsa) has been created for you!"
		_echo "Here is the key:"
		echo "$(cat $HOME/.ssh/id_rsa.pub)"
	fi

	# finalize
	_echo "Reloading ~/.zshrc."
	exec "$SHELL"
	source ~/.zshrc
	_echo ".dotfiles setup complete! Enjoy living in a world of monogamy."
}

# invoke main
main