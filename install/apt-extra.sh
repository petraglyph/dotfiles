#!/bin/sh
# Extra APT Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles


packages="
btrbk
btrfs-compsize
clang
ffmpeg
git-email
gnuplot
imagemagick
jq
libimage-exiftool-perl
nethogs
python3-dev
qalc
ranger
rclone
ssmtp
tldr
"

$(dirname $0)/apt.sh $packages $@
