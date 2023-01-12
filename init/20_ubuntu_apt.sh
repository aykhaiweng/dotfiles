#!/usr/bin/env bash

# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# Disable frontend for some installers
export DEBIAN_FRONTEND=noninteractive
export TZ=Asia/Kuala_Lumpur
sudo apt-get -y install tzdata

# Commands
apt_ppa=()
apt_packages=(
    apt-transport-https
    bat
    build-essential
    ca-certificates 
    certbot
    cmake
    curl
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
    libxml2-dev
    libxmlsec1-dev
    llvm
    make
    nodejs
    npm
    silversearcher-ag
    software-properties-common
    tk-dev
    wget
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
sudo add-apt-repository ${apt_ppa[*]// /\s}
sudo apt update

# Install the apt packages
e_arrow "Installing apt packages"
sudo apt install -qy ${apt_packages[*]// /\s}

# Install pyenv
if [[ -d "$HOME/.pyenv" ]]; then
    e_arrow "pyenv is already installed"
else
    e_success "Installing pyenv"
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
fi
