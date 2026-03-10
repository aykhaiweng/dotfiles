# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

if is_installed docker; then
  e_arrow "Docker is already installed."
else
  e_header "Installing Docker for Ubuntu"

  (
    set -e
    # Add Docker's official GPG key:
    sudo apt-get -qq update && sudo apt-get install -y ca-certificates curl

    # Create keyring directory safely
    sudo install -m 0755 -d /etc/apt/keyrings

    if [ ! -f "/etc/apt/keyrings/docker.asc" ]; then
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc
    fi

    # Add the repository to Apt sources:
    if [ ! -f "/etc/apt/sources.list.d/docker.list" ]; then
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    fi

    # update the sources
    sudo apt-get -qq update

    # Finally, we install Docker
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  ) || { e_error "Docker installation failed."; return 1; }
fi

# Add this user to the Docker user group (idempotent)
if groups "$USER" | grep -q "\bdocker\b"; then
  e_arrow "User $USER is already in the docker group."
else
  sudo usermod -aG docker "$USER"
  e_success "Added user $USER to the docker group."
fi
