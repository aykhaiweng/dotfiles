#!/usr/bin/env bash

is_osx && alias ls="ls -ACF --color=auto"
is_ubuntu && alias ls="ls -aCF --color=auto"

alias ll="ls -l --color=auto"