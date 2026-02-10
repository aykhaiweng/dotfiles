#!/bin/bash

# Configuration
KEY_NAME="GitHub Key"
KEY_EMAIL="aykhaiweng@gmail.com"
PASSPHRASE="${GPG_PASSPHRASE:-}"
KEY_TYPE="RSA"
KEY_LENGTH=4096

# Create a batch file for non-interactive generation
cat >gpg_batch <<EOF
     %echo Generating a basic OpenPGP key
     Key-Type: $KEY_TYPE
     Key-Length: $KEY_LENGTH
     Subkey-Type: ELG-E
     Subkey-Length: $KEY_LENGTH
     Name-Real: $KEY_NAME
     Name-Email: $KEY_EMAIL
     Expire-Date: 0
     Passphrase: "$PASSPHRASE"
     %commit
     %echo done
EOF

# Generate the key
gpg --batch --generate-key gpg_batch

# Identify the Key ID
KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$KEY_EMAIL" | grep 'sec' | awk '{print $2}' | cut -d'/' -f2)

# Export the public key
echo "--- COPY THE KEY BELOW ---"
gpg --armor --export "$KEY_ID"

# Cleanup
rm gpg_batch

echo "Go here to update your keys: https://github.com/settings/keys"
