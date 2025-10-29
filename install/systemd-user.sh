#!/bin/sh
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
LOC="$HOME/.dotfiles"
TARGET="$HOME/.local/share/systemd/user"

mkdir -p $TARGET
cp $LOC/configs/systemd/backup-dotfiles.* $TARGET

systemctl --user enable backup-dotfiles.timer
systemctl --user restart backup-dotfiles.timer
