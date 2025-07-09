# ~/.zshrc

# Source the alias file from dotfiles
if [ -f ~/dotfiles/aliases.sh ]; then
  . ~/dotfiles/aliases.sh
fi

r()
{
    "$@" > /dev/null/2>&1 & disown
}

# Create aliases
alias nvm='nvim'                        
alias ls='ls -al'

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
