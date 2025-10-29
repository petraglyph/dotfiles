# Fish add to PATH
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
for bin in /var/lib/flatpak/exports/bin $HOME/.local/share/flatpak/exports/bin $HOME/.cargo/bin /usr/local/bin $HOME/.local/bin
	if ! test -d $bin
		continue
	end
	if string match -q $bin $PATH
		continue
	end
	set -gpx PATH $bin
end
