#!/bin/sh
# Extra APT Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles


packages="
clang
ffmpeg
git-email
gnuplot
imagemagick
jq
libimage-exiftool-perl
nethogs
python3-devel
qalc
ranger
rclone
ssmtp
tldr
"

$(dirname $0)/apt.sh $packages $@
