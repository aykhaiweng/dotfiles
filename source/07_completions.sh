#!/usr/bin/env bash

# User completions
# gcloud completion comes from oh-my-zsh's gcloud plugin; point it at
# Linuxbrew's SDK, which it doesn't search
if [[ -d /home/linuxbrew/.linuxbrew/share/google-cloud-sdk ]]; then
  CLOUDSDK_HOME=/home/linuxbrew/.linuxbrew/share/google-cloud-sdk
fi
