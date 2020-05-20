#!/bin/bash

###############################################################################
# Linux Setup
###############################################################################

_echo() {
    echo "[aykhaiweng says] [LINUX] - $1"
}

_append_to_file() {
    string=$1
    filepath=$2
    attr=$(grep -Fx "$string" $filepath)
    if [ $attr ] ; then
        echo "[FOUND] '$string' in '$filepath'"
    else
        echo "[APPEND] '$string' to '$filepath'"
        echo "$string" | sudo tee -a $filepath
    fi
}

DBPASSWRD='topkek'


# prompt for sudo
sudo -v


main() {
    if ! [ $KURA_FTS ] ; then
        _echo "Setting up locales"
        sudo locale-gen en_US.UTF-8
        sudo timedatectl set-timezone Asia/Kuala_Lumpur
    fi

    # Install essentials
    _echo "Installing essentials."
    _echo
    echo "@================================================="
    echo "| khai.IO                                        |"
    echo "|                                                |"
    echo "| The following programs will be                 |"
    echo "| installed:-                                    |"
    echo "|    1. python3              8. nginx            |"
    echo "|    2. python3-pip          9. gunicorn         |"
    echo "|    3. python-dev           10. git             |"
    echo "|    4. libpq-dev            11. memcached       |"
    echo "|    5. NO MORE POSTGRESQL   12. system-services |"
    echo "|    6. NO MORE MYSQL        13. nodejs-legacy   |"
    echo "|    7. libjpeg8-dev         14. npm             |"
    echo "|                                                |"
    echo "|                    And loads of other goodies! |"
    echo "@================================================="
    echo

    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install apt-transport-https -y
    _echo "Installing essentials"
    sudo apt install -y  --assume-yes apt-transport-https build-essential curl wget file \
        ca-certificates software-properties-common \
        make build-essential libssl-dev zlib1g-dev libbz2-dev \
        autotools-dev autoconf \
        libffi-dev libssl-dev libxml2-dev libxslt1-dev \
        libreadline-dev libncurses5-dev libncursesw5-dev llvm \
        libffi-dev liblzma-dev python-openssl xz-utils tk-dev \
        libpq-dev gettext \
        libjpeg8-dev \
        byacc binutils gdal-bin \
        silversearcher-ag \
        cmake zsh tmux neovim xclip \

    # Install Docker
    _echo "Installing Docker"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt update -y
    apt-cache policy docker-ce
    sudo apt install docker-ce -y

    # Install Vagrant
    _echo "Installing Vagrant"
    sudo apt install vagrant -y

    # Install Ansible
    _echo "Installing Ansible"
    sudo apt install ansible -y

    # terminal essentials
    sudo apt install mosh -y
}

# invoke main
main
