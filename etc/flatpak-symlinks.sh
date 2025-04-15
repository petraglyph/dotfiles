#!/bin/sh
# Symlink Flatpak Configs to Convenient Directories
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles


checked_link () {
	APP_DIR="$1"
	TARGET="$2"

	if [ -e "$TARGET" ]; then
		if [ ! -L "$TARGET" ]; then
			echo "$TARGET already exists"
		elif [ "$(realpath "$TARGET")" != "$APP_DIR" ]; then
			echo "$TARGET is an unknown symlink"
			echo "$(realpath "$TARGET") != $APP_DIR"
		fi
	else
		ln -fs "$APP_DIR" "$TARGET"
	fi
}


printf "\033[1;32m%s\033[0m\n" "[Flatpak symlinks] Linking ~/.minecraft/"
MC_DIR="$HOME/.var/app/com.mojang.Minecraft/.minecraft"
mkdir -p $MC_DIR/saves $MC_DIR/resourcepacks
checked_link $MC_DIR $HOME/.minecraft

printf "\033[1;32m%s\033[0m\n" "[Flatpak symlinks] Linking ~/.config/fragments"
DIR="$HOME/.var/app/de.haeckerfelix.Fragments/config/fragments"
checked_link $DIR $HOME/.config/fragments
