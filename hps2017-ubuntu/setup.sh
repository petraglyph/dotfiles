#!/bin/bash
# Setup hps2017
#   Ubuntu

# Check install location
source "$(dirname $BASH_SOURCE)/../install/check.sh"

comp="hps2017-ubuntu"

# Ubuntu Installs
bash ~/.dotfiles/install/ubuntu.sh
# General Configuration
bash ~/.dotfiles/install/configure.sh $comp
