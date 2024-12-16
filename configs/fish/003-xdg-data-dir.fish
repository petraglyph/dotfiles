# Fish add to XDG_DATA_DIRS
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
for data in $HOME/.local/share/flatpak/exports/share /usr/local/share /usr/share
	if ! test -d $data
		continue
	end
	if string match -rq $data $XDG_DATA_DIRS
		continue
	end
	set -gpx XDG_DATA_DIRS $data
end
