#!/bin/sh
# AutiInstall Rust
#   Penn Bauman <me@pennbauman.com>

# Do nothing if already installed
if [ -d $HOME/.cargo ]; then
	printf "\033[1;32m%s\033[0m\n" "[rustup] Rust already installed"
	exit
fi

printf "\033[1;32m%s\033[0m\n" "[rustup] Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
