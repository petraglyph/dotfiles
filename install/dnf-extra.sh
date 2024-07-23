#!/bin/sh
# Extra DNF Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles


packages="
android-tools
clang
cronie
ffmpeg
git-email
gnuplot
nethogs
nodejs
python3-devel
qalc
rclone
squashfs-tools-ng
ssmtp
tldr
"

$(dirname $0)/dnf.sh $packages $@
