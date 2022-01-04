#!/usr/bin/env bash

# 2>&1 is for routing stderr to stdout

eval `ssh-agent` > /dev/null 2>&1
ssh-add -D > /dev/null 2>&1
ssh-add > /dev/null 2>&1
