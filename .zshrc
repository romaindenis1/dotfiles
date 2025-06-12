# ~/.zshrc

# Source the alias file from dotfiles
if [ -f ~/dotfiles/aliases.sh ]; then
  . ~/dotfiles/aliases.sh
fi

r()
{
    "$@" > /dev/null/2>&1 & disown
}

