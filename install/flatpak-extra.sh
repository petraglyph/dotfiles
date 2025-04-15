#!/bin/sh
# Flatpak Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles


packages="
org.mozilla.Thunderbird
com.mojang.Minecraft
de.haeckerfelix.Fragments
com.discordapp.Discord
org.inkscape.Inkscape
org.signal.Signal
org.gnome.Fractal
app.drey.Dialect
"

$(dirname $0)/flatpak.sh $packages $@
