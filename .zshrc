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


securestore() {
  nix-shell -p gcc cargo rustc --run "cd ~/dotfiles/scripts/securestore && cargo run -- \"$@\""
}


securestore_encrypt() {
  local source_folder=~/dotfiles/obsidian
  local output_basename=backup
  local output_dir=~/dotfiles
  local password_file=~/dotfiles/scripts/securestore/pwd.secret

  #expand ~
  output_dir="${output_dir/#\~/$HOME}"
  source_folder="${source_folder/#\~/$HOME}"
  password_file="${password_file/#\~/$HOME}"

  #remove previous backup
  rm -f "$output_dir/${output_basename}_*.enc"

  nix-shell -p gcc rustc cargo --run "
    cd ~/dotfiles/scripts/securestore && \
    cargo run -- -e \"$source_folder\" \"$output_dir/$output_basename.enc\" \"$password_file\"
  "
}

securestore_decrypt() {
  local backup_dir=~/dotfiles
  local password_file=~/dotfiles/scripts/securestore/pwd.secret
  local output_folder=~/dotfiles/obsidian

  backup_dir="${backup_dir/#\~/$HOME}"
  password_file="${password_file/#\~/$HOME}"
  output_folder="${output_folder/#\~/$HOME}"

  #\ls because i have an alias
  local latest_backup
  latest_backup=$(\ls -1t "$backup_dir"/backup_*.enc 2>/dev/null | head -n 1)

  if [[ -z "$latest_backup" ]]; then
    echo "Error: No backup file found in $backup_dir"
    return 1
  fi

  echo "Using backup file: $latest_backup"

  nix-shell -p gcc rustc cargo --run "
    cd ~/dotfiles/scripts/securestore && \
    cargo run -- -d \"$latest_backup\" \"$output_folder\" \"$password_file\"
  "
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

#Fetch for repo when cd into one
#Not good for resources probably but it looks nice
LAST_REPO=""

cd() {
	builtin cd "$@"
	git rev-parse 2>/dev/null

	if [ $? -eq 0 ]; then
		if [ "$LAST_REPO" != $(basename $(git rev-parse --show-toplevel)) ]; then
			onefetch
			LAST_REPO=$(basename $(git rev-parse --show-toplevel))
		fi
	fi
}
