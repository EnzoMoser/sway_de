
# Set the target to $XDG_CONFIG_HOME, otheriwse $HOME/.config. 
if [[ -n "$XDG_CONFIG_HOME" ]]; then
   sed -i 's/--target.*/--target=\$XDG_CONFIG_HOME/' .config/.stowrc
else
   sed -i 's/--target.*/--target=\$HOME\/\.config/' .config/.stowrc
fi

# Install using stow
stow -n .config # Dry-run only right now
