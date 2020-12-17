#!/bin/sh
# Fedora Server Installs

loc="$HOME/.dotfiles"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "none"

#message "Enabling copr Repositories"
copr() {
	result=$(sudo dnf -y copr enable $1 2>&1 | tail -1)
	if [[ $result != "Bugzilla. In case of problems, contact the owner of this repository." ]]; then
		echo $result
	fi
}

packages="
git
zsh
neovim
ranger
nethogs
nodejs
htop
clang
"
message "Install Packages"
sudo dnf -y install $packages --skip-broken
