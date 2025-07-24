if [ -f ~/dotfiles/aliases.sh ]; then
  . ~/dotfiles/aliases.sh
fi

r()
{
    "$@" > /dev/null/2>&1 & disown
}

alias nvm='nvim'                        
alias cls='clear'

nxconfig() {
 sudo nvim /etc/nixos/configuration.nix
}

nxbuild() {
  sudo nixos-rebuild switch
}

#TODO need to figure out how to do this with alot of things
#Dont really want to make it manually -- maybe another script ? :)) 
randomstring() {
  (cd ~/dotfiles/scripts/randomString && cargo run -- "$@")
}


#Makes new rust project with dumb shell.nix inside because it doesnt make it automatically
#and i dont want to make it everytime
newrust() {
  if [ -z "$1" ]; then
    echo "Usage: newrust <project_name>"
    return 1
  fi

  local name=$1
  cargo new "$name" || return 1

  cat > "$name/shell.nix" <<EOF
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.rustc
    pkgs.cargo
    pkgs.rustfmt
    pkgs.gcc
    pkgs.pkg-config
    pkgs.gnumake
  ];
}
EOF
  echo "use nix" > "$name/.envrc"
  echo "Project '$name' created with shell.nix and .envrc"
}

refreshshell()
{
  source ~/.zshrc
}

#TODO: Make scripts for securestore crypt and decrypt i cant be bothered right now 

