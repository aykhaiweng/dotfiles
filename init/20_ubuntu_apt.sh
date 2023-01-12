#!/usr/bin/env bash

# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# Disable frontend for some installers
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install build-essential apt-transport-https software-properties-common unzip cmake make

# Commands
apt_ppa=()
apt_packages=(
    bat
    ca-certificates 
    certbot
    curl
    gettext
    gnupg-agent
    jq
    libbz2-dev
    libc6-dev
    libffi-dev
    liblzma-dev
    libncurses5-dev
    libpq-dev
    libreadline-dev
    libsqlite3-dev
    libssl-dev
    libtool-bin
    libxml2-dev
    libxmlsec1-dev
    llvm
    nodejs
    npm
    silversearcher-ag
    tk-dev
    wget
    xclip
    xz-utils
    zlib1g-dev
    zsh
)

# General install
e_arrow "Running apt update"
sudo apt update -y
e_arrow "Running apt autoremove"
sudo apt autoremove -y
e_arrow "Running apt upgrade"
sudo apt upgrade -y

# Latest vim
apt_ppa+=("ppa:jonathonf/vim")
apt_packages+=(vim)

# Latest neovim
apt_ppa+=("ppa:neovim-ppa/unstable")
apt_packages+=(neovim)

# Docker
e_arrow "Installing Docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -  # Docker's official GPG key
apt_ppa+=("deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable")
apt_packages+=(docker.io)

# Adding apt repositories
e_arrow "Adding apt repositories"
for entry in "${apt_ppa[@]}"; do
    sudo add-apt-repository -y $entry
done
sudo apt update

# Install the apt packages
e_arrow "Installing apt packages"
formatted_packages=${apt_packages[*]// /\s}
e_arrow "$formatted_packages"
sudo apt install -qy $formatted_packages

# Install pyenv
if [[ -d "$HOME/.pyenv" ]]; then
    e_arrow "pyenv is already installed"
else
    e_arrow "Installing pyenv..."
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    e_success "Pyenv installed."
fi
