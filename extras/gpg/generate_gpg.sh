#!/bin/bash

# Configuration
KEY_NAME="GitHub Key"
KEY_EMAIL="aykhaiweng@gmail.com"
KEY_TYPE="RSA"
KEY_LENGTH=4096

# Check if GPG_PASSPHRASE is set and not empty
if [ -n "$GPG_PASSPHRASE" ]; then
    PASSPHRASE_LINE="Passphrase: $GPG_PASSPHRASE"
    PROTECTION_LINE=""
else
    # If no env var, use %no-protection to skip passphrase prompts entirely
    PASSPHRASE_LINE=""
    PROTECTION_LINE="%no-protection"
fi

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
     $PASSPHRASE_LINE
     $PROTECTION_LINE
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
