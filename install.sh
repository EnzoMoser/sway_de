#!/usr/bin/env bash
set -eo pipefail # Exit if any command fails. Print command.

# Get the correct location for this file.
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

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
cd $DIR/.config # Cd into dotfile config
stow .
cd $DIR # Cd back out

echo "DONE!!!"
