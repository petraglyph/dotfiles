#!/bin/sh
# Extra APT Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles


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
