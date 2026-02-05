#!/usr/bin/env bash


if [[ -f "~/.ssh/id_ed25519" ]]; then
    e_arrow "Default ssh key already exists."
else
    e_arrow "Generating default ssh key..."
    ssh-keygen -t ed25519
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519


    e_success "ssh key generated."
    cat ~/.ssh/id_ed25519
    e_arrow "Press ENTER when you have copied this to your GitHub account."
    read UserInput
fi
