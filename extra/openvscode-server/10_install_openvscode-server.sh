#!/usr/bin/env bash

VERSION="1.64.2"
DOWNLOAD_URL="https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v${VERSION}/openvscode-server-v${VERSION}-linux-x64.tar.gz"

echo "> Downloading from $DOWNLOAD_URL"
# Download the specified version
wget "$DOWNLOAD_URL" -O "/tmp/openvscode-server-v$VERSION-linux-x64.tar.gz"
# Extract the tar
tar -xzf "/tmp/openvscode-server-v$VERSION-linux-x64.tar.gz" -C /tmp/
# Check for an existing installation
if [[ -d "/opt/openvscode-server/" ]]; then
    # Remove if we can find it
    echo "> Deleting existing version of openvscode-server"
    rm -r /opt/openvscode-server/
fi
# Copy the latest version
cp -r "/tmp/openvscode-server-v$VERSION-linux-x64" /opt/openvscode-server/