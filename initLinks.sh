# Nix config file

sudo ln -SF /home/r/dotfiles/nixos/configuration.nix /etc/nixos/configuration.nix

# Git config (Forgot to do this somehow)
sudo ln -SF /home/r/dotfiles/.gitconfig /home/r/.gitconfig

#Waybar
mkdir -p ~/.config/waybar
ln -SF ~/dotfiles/waybar/config ~/.config/waybar/config
ln -SF ~/dotfiles/waybar/style.css ~/.config/waybar/style.css

