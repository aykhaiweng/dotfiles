# OSX-only stuff. Abort if not OSX.
is_ubuntu || return 1

e_header "Installing Docker for Ubuntu"

# Add Docker's official GPG key:
sudo apt update && sudo apt install -y ca-certificates curl

# Create keyring directory safely
sudo install -m 0755 -d /etc/apt/keyrings

if [ ! -f "/etc/apt/keyrings/docker.asc" ]; then
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
fi

# Add the repository to Apt sources:
if [ ! -f "/etc/apt/sources.list.d/docker.sources" ]; then
  # Create the sources file using the current OS codename
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

# update the sources
sudo apt update

# Finally, we install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add this user to the Docker user group
sudo usermod -aG docker $USER
