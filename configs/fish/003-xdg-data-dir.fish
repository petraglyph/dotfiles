# Fish add to XDG_DATA_DIRS
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
for data in $HOME/.local/share/flatpak/exports/share /usr/local/share /usr/share
	if ! test -d $data
		continue
	end
	if string match -rq $data $XDG_DATA_DIRS
		continue
	end
	set -gpx XDG_DATA_DIRS $data
end
