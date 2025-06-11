#!/bin/bash

# Create aliases
alias nvm='nvim'                        
alias ls='ls -al'

# Functions for common tasks
nxconfig() {
  # Open the NixOS configuration file with nvim
  nvim /etc/nixos/configuration.nix
}

nxbuild() {
  # Run sudo nixos-rebuild switch
  sudo nixos-rebuild switch
}
