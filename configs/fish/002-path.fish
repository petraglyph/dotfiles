# Fish add to PATH
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
for bin in $HOME/.local/share/flatpak/exports/bin $HOME/.cargo/bin /usr/local/bin $HOME/.local/bin
	if ! test -d $bin
		continue
	end
	if string match -q $bin $PATH
		continue
	end
	set -gpx PATH $bin
end
