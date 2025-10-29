#!/bin/sh
# Install LaTeX Tools
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

os_id="$(grep '^ID=' /etc/os-release | cut -d'=' -f 2)"


if [ "$os_id" = "fedora" ]; then
	printf "\033[1;32m%s\033[0m\n" "[LaTeX] Installing (DNF)"
	packages="latexmk texlive-latex texlive-scheme-medium"
	sudo dnf -y --setopt=install_weak_deps=False install $packages
else
	echo "Unknown OS '$os_id'"
	exit 1
fi
