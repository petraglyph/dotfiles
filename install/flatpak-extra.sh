#!/bin/sh
# Flatpak Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles


packages="
app.drey.Dialect
de.haeckerfelix.Fragments
org.chromium.Chromium
org.gnome.Fractal
org.inkscape.Inkscape
org.mozilla.Thunderbird
org.nickvision.tubeconverter
org.prismlauncher.PrismLauncher
org.signal.Signal
"

$(dirname $0)/flatpak.sh $packages $@
