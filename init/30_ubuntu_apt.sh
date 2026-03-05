# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

e_header "Updating APT"
sudo apt-get -qq update

packages=(build-essential curl git)
installed_pkgs=$(dpkg-query -W -f='${Package}\n' "${packages[@]}" 2>/dev/null || true)

for pkg in "${packages[@]}"; do
   if ! echo "$installed_pkgs" | grep -qxF "$pkg"; then
       e_header "Installing $pkg..."
       sudo apt-get install -y "$pkg"
   else
       e_arrow "$pkg is already installed."
   fi
done

if is_dotfiles_bin; then
    e_header "Upgrading APT packages"
    sudo apt-get -qy upgrade
else
    e_header "Dist-upgrading APT packages"
    sudo apt-get -qy dist-upgrade
fi



