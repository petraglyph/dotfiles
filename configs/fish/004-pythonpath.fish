# Fish set PYTHONPATH
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
if command -qv python3
	if test -z $PYTHONPATH
		set -l python_str (python3 -V | sed -E -e 's/\.[0-9]+$//' -e 's/^.* /python/')
		set -gx PYTHONPATH $HOME/.local/lib/$python_str/site-packages
	end
end
