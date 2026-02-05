# OSX-only stuff. Abort if not OSX.
is_ubuntu || return 1

e_header "Updating APT"
sudo apt-get -qq update
sudo apt install -y build-essential

if is_dotfiles_bin; then
    sudo apt-get -qy upgrade
else
    sudo apt-get -qy dist-upgrade
fi