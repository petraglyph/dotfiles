#!/bin/sh
# AutiInstall Rust
#   Penn Bauman <me@pennbauman.com>

# Do nothing if already installed
if [ -d $HOME/.cargo ]; then
	exit
fi

message="Installing Rust (with rustup)"
if [ -z $BASH_SOURCE ]; then
	echo "\033[1;32m$message\033[0m"
else
	echo -e "\033[1;32m$message\033[0m"
fi
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
