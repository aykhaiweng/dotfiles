#!/bin/bash

# Configuration
EMAIL="aykhaiweng@gmail.com"

# 1. Retrieve the Long Key ID for the given email
# We use 'head -n 1' in case multiple keys exist for the same email
KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$EMAIL" | grep 'sec' | awk '{print $2}' | cut -d'/' -f2 | head -n 1)

if [ -z "$KEY_ID" ]; then
    echo "Error: No GPG key found for $EMAIL"
    exit 1
fi

# 2. Configure Git globally
git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true

echo "Git successfully configured to use GPG key: $KEY_ID"
