#!/usr/bin/env bash
set -eo pipefail # Exit if any command fails. Print command.

# Get the absolute location for this file.
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
# Get the absolute directory.
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

# Set the target to $XDG_CONFIG_HOME, otheriwse $HOME/.config. 
if [[ -n "$XDG_CONFIG_HOME" ]]; then
   sed -i 's/--target.*/--target=\$XDG_CONFIG_HOME/' $DIR/.config/.stowrc
else
   sed -i 's/--target.*/--target=\$HOME\/\.config/' $DIR/.config/.stowrc
fi

# Setup symlinks using stow
echo "Calling 'stow' within directoires to symlink..."
cd $DIR/.config # Cd into dotfile config
stow .
cd $DIR # Cd back out

# If the command 'pacman' exists, use it to install packages.
echo "Checking if command 'pacman' exists..."
if command -v pacman &> /dev/null; then
  echo "pacman exists! Installing packages..."
  # Return space separated list of packages.
  essential_pkg=$(awk -F '#' 'BEGIN{OFS="#";} { if (!/#/) ;else $NF="";print $0}' $DIR/package-list.txt | sed -n 's/#$//g;p' | grep -v "^$" | tr '\n' ' ')
  sudo pacman -S --needed --noconfirm $essential_pkg
else
  # Otherwise, ask if script should continue.
  echo "WARNING: Package manager pacman not found. Packages MUST be installed manually."
fi

echo "DONE!!!"
