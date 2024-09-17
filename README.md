# My Sway Desktop Environment
This is my current desktop environment setup for the sway window manager. Credits to [EndeavourOS Sway-WM](https://github.com/EndeavourOS-Community-Editions/sway) for the initial configuration.

## Prerequisites
**WARNING! You must backup your files yourself!!!** This script does **not** backup on your behalf.

Make sure you have the packages from ```package-list.txt```. The install script will automatically install them if you use Arch. Otherwise, find the equivalent package for your distro and install manually before running the script.

## Install
Run install.sh

## Usage
There is no login manager. Type ```sway``` in the terminal to start a sway session.

This setup creates symbolic links from the ```$SOME_PATH/sway_de/.config/``` folder to your ```$HOME/.config/``` (replace ```$SOME_PATH``` with whichever directory you placed ```sway_de/``` in). Symbolic links are managed using [GNU Stow](https://www.gnu.org/software/stow/). It is recommended you read the man pages ```man stow```, or for more information ```info stow```.

You can use all the ```stow``` commands when inside ```$SOME_PATH/sway_de/.config/```. For example:

To sync symbolic links from ```$HOME/.config/``` pointing to ```$SOME_PATH/sway_de/.config/```:
```console
$ cd $SOME_PATH/sway_de/.config/
$ stow --restow .
```

To remove all valid symbolic links from ```$HOME/.config/``` pointing to ```$SOME_PATH/sway_de/.config/```:
```console
$ cd $SOME_PATH/sway_de/.config/
$ stow --delete .
```

To remove invalid symbolic links (for when you change the directory for ```sway_de``` and now all symbolic links point to path that no longer exists. They need to be deleted with this command and only then added back using the install script or ```stow```):
```console
$ find ~/.config/ -xtype l -exec rm {} +
```

## Uninstall
There is currently no uninstall script. You can simply delete any files you are no longer using.
