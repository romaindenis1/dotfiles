#!/bin/bash

# Create aliases
alias nvm='nvim'                        

alias cls='clear'

# Functions for common tasks
nxconfig() {
  # Open the NixOS configuration file with nvim
 sudo nvim /etc/nixos/configuration.nix
}

nxbuild() {
  # Run sudo nixos-rebuild switch
  sudo nixos-rebuild switch
}

#TODO: make obsidian links
