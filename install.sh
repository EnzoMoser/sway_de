#!/usr/bin/env bash
set -eo pipefail # Exit if any command fails. Print command.

echo "Checking if command 'pacman' exists..."
# If the command pacman exists, use it to install packages.
if command -v pacman &> /dev/null; then
  echo "pacman exists! Installing packages..."
  # Return space separated list of packages.
  export essential_pkg=$(awk -F '#' 'BEGIN{OFS="#";} { if (!/#/) ;else $NF="";print $0}' package-list.txt | sed -n 's/#$//g;p' | grep -v "^$" | tr '\n' ' ')
  sudo pacman -S $essential_pkg
else
  echo "WARNING: Package manager pacman not found. Packages MUST be installed manually."
  read -p ":: Continue to symlink dotfiles? [y/N]: " -n 1 -r
  echo    # (optional) move to a new line
  if [[ "$REPLY" != "y" && "$REPLY" != "Y" ]]; then
    echo "Exiting without symlinking..."
    exit 1
  fi
fi

# Set the target to $XDG_CONFIG_HOME, otheriwse $HOME/.config. 
if [[ -n "$XDG_CONFIG_HOME" ]]; then
   sed -i 's/--target.*/--target=\$XDG_CONFIG_HOME/' .config/.stowrc
else
   sed -i 's/--target.*/--target=\$HOME\/\.config/' .config/.stowrc
fi

echo "Calling 'stow' within directoires to symlink..."
# Setup symlinks using stow
cd .config
stow .
cd ..

echo "DONE!!!"
