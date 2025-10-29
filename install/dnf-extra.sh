#!/bin/sh
# Extra DNF Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles


packages="
android-tools
btrbk
clang
duperemove
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
